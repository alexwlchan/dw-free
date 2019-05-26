#!/usr/bin/perl
#
# LJ::Directory::Constraint::TrustedBy
#
# This defines the directory constraint for getting the list of userids that
# are trusted by the given user.
#
# Authors:
#      Janine Smith <janine@netrophic.com>
#
# Copyright (c) 2009 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself.  For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldoc perlgpl'.
#

package LJ::Directory::Constraint::TrustedBy;
use strict;
use warnings;
use base 'LJ::Directory::Constraint';
use Carp qw( croak );

sub new {
    my ( $pkg, %args ) = @_;
    my $self = bless {}, $pkg;
    $self->{$_} = delete $args{$_} foreach qw( userid user );
    croak "unknown args" if %args;
    return $self;
}

sub new_from_formargs {
    my ( $pkg, $args ) = @_;
    return undef unless $args->{user_trusted_by} xor $args->{userid_trusted_by};
    return $pkg->new(
        user   => $args->{user_trusted_by},
        userid => $args->{userid_trusted_by}
    );
}

sub cache_for { 5 * 60 }

sub u {
    my $self = shift;
    return $self->{u} if $self->{u};
    $self->{u} =
        $self->{userid} ? LJ::load_userid( $self->{userid} ) : LJ::load_user( $self->{user} );
}

sub matching_uids {
    my $self = shift;
    my $u    = $self->u or return ();
    return $u->trusted_userids;
}

1;
