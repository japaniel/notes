#!/usr/bin/perl
package Perlnotes;

use strict;
use warnings;
use File::Path qw(make_path);
use Git::Repository;
use Proc::Daemon;

use Data::Dumper;

#TODO read settings in from .notesrc
my $SETTINGS = {
  NOTES_DIR => "$ENV{HOME}/.perlnotes",
  EDITOR => 'vim',
};

sub new {
  my $class = shift;

  my $self = {};
  bless $self, "$class" ;

  $self->setup($SETTINGS->{NOTES_DIR}) unless defined($self->{setup});
  $self->{repo} = get_repo($abs_path) unless defined($self->{repo});

  return $self;
}

#ancillery setup
sub setup {
  my ($self, $abs_path) = @_;

  make_path( "$abs_path", { verbose => 1,  mode => 0755,});
  Git::Repository->run( init => $abs_path );

  $self->{setup} = 1;
} 

sub create {
  my ($self, $file) = @_;
  my $abs_path = "$SETTINGS->{NOTES_DIR}/$file";

  system($SETTINGS->{EDITOR}, $abs_path);

}

sub edit {
  print "Sorry, you'll have to wait till next year for that feature";
}

sub start {
  #for now just set 'started' attr until we get auto watching working Inotify2
  my ($self) = @_;

  $self->{started} = 1;
}

sub get_repo {
  my ($dir) = @_;

  Git::Repository->new( work_tree => "$dir/.git" );
}
