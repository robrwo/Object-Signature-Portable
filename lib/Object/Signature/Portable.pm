package Object::Signature::Portable;

use strict;
use warnings;

use Carp;
use Crypt::Digest;
use Exporter::Lite;
use JSON::MaybeXS;

use version 0.77; our $VERSION = version->declare('v0.1.0');

our @EXPORT = qw/ signature /;
our @EXPORT_OK = @EXPORT;

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

sub signature {
    my %args;

    if (scalar(@_) <= 1) {
        $args{data} = $_[0];
    } else {
        %args = @_;
    }

    $args{digest} //= 'MD5';

    $args{method} //= 'hexdigest';
    unless ($args{method} =~ m/^(?:hex|b64u?)digest$/) {
        croak sprintf('Invalid digest method: %s', $args{method});
    }

    $args{serializer} //= sub {
        return
            JSON->new->canonical(1)->allow_nonref(1)->utf8(1)
            ->pretty(0)->indent(0)->space_before(0)->space_after(0)
            ->allow_blessed(1)->convert_blessed(1)
            ->encode( $_[0] );
    };

    my $digest = Crypt::Digest->new( $args{digest} );
    $digest->add( &{$args{serializer}}( $args{data} ) );

    if (my $method = $digest->can($args{method})) {
        return $digest->$method;
    } else {
        croak sprintf('Unexpected error with digest method: %s', $args{method});
    }
}

=head1 EXPORTS

=head2 C<signature>

    my $sig = signature( $object );

    my $sig = signature( digest => 'MD5', data => $object );

This returns an hexidecimal signature of the object.

=cut

=head1 SEE ALSO

=over

=item L<Object::Signature>

This uses L<Storable> to serialise objects and generate a MD5
hexidecimal string as a signature.

This has the drawback that machines with different versions of Perl or
L<Storable> may not produce the same signature for the same data.

=back

=head1 AUTHOR

Robert Rothenberg <rrwo@cpan.org> (on behalf of Foxtons, Ltd.)

=cut

1;
