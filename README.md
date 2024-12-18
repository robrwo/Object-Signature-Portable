# NAME

Object::Signature::Portable - generate portable fingerprints of objects

# VERSION

version v1.2.2

# SYNOPSIS

```perl
use Object::Signature::Portable;

my $sig = signature( $object ); # MD5 hex of object signature

my $sig = signature(
  digest => 'SHA1',             # SHA-1 digest
  format => 'b64udigest',       # as URL-safe base-64
  data   => $object,
);
```

# DESCRIPTION

This module provides a simple function for generating _portable_
digital fingerprints (a.k.a. signatures, not to be confiused with
public key signatures.) of Perl data structures.

The object is serialized into a canonical JSON structure, and then
hashed using the MD5 algorithm.

Any two machines running different versions of Perl on different
architectures should produce identical signatures.

Note that this module is useful in cases where the consistency of
signatures between machine is more important than the speed of
signature generation.

However, the serialization method, hash algorithm and signature format
can be customized, as needed.

# EXPORTS

## `signature`

```perl
my $sig = signature( $data );

my $sig = signature(
  data       => $data,
  digest     => 'MD5',         # default
  format     => 'hexdigest',   # default
  serializer => sub { ... },
);
```

Generate a digital fingerprint of the `$data`.

The following options are supported:

- `digest`

    The cryptographic digest algorithm, as supported by [Crypt::Digest](https://metacpan.org/pod/Crypt%3A%3ADigest).

- `format`

    The [Crypt::Digest](https://metacpan.org/pod/Crypt%3A%3ADigest) formatting method for the signature, which can be
    one of:

    - `digest`

        The raw bytes of the digest.

    - `hexdigest`

        The digest as a string of hexidecimal numbers.

    - `b64digest`

        The digest as a MIME base-64 string.

    - `b64udigest`

        The digest as a URL-friendly base-64 string.

- `prefix`

    If set to a true value, the digest is prefixed by the name of the
    digest algorithm.

    This is useful when you may want to change the digest algorithm used
    by an application in the future, but do not want to regenerate
    signatures for existing objects in a data store.

- `serializer`

    The serialization method, which is a subroutine that takes the data as
    a single argument, and returns the serialized data to be hashed.

    It is recommended that you use a serializer that produces canonical
    (normalized) output, and preferably one that produces consistent
    output across all of the platforms that you are using.  ([YAML](https://metacpan.org/pod/YAML),
    [Data::Dumper](https://metacpan.org/pod/Data%3A%3ADumper) or [Sereal::Encoder](https://metacpan.org/pod/Sereal%3A%3AEncoder) should be acceptable
    alternatives, provided that you enable canonical encoding, and in the
    case of Sereal, explicitly specify a protocol version.)

    By default, it uses [JSON::MaybeXS](https://metacpan.org/pod/JSON%3A%3AMaybeXS). The choice for using JSON is
    based on the following considerations:

    - JSON is a simple, text-based format. The output is not likely to
    change between module versions.
    - Consistent encoding of integers and strings.
    - Classes can be extended with hooks for JSON serialization.
    - Speed is not a factor.

    However, see ["LIMITATIONS"](#limitations) below.

# LIMITATIONS

## Encoding

The default JSON serializer will use UTF-8 encoding by default, which
generally removes an issue with [Storable](https://metacpan.org/pod/Storable) when identical strings
have different encodings.

Numeric values may be inconsistently represented if they are not
numified, e.g. `"123"` vs `123` may not produce the same JSON. (This too
is an issue with `Storable`.)

## Signatures for Arbitrary Objects

By default, this module uses [JSON::MaybeXS](https://metacpan.org/pod/JSON%3A%3AMaybeXS) to serialize Perl objects.

This requires the objects to have a `TO_JSON` method in order to be
serialized.  Unfortunately, this is not suitable for many objects
(particularly those generated by modules that are not under your
control, e.g. many CPAN modules) without monkey-patching or
subclassesing them.

One solution is to use a different serializer that can handle the
object.

Alternatively, you can write a wrapper function that translates an
object into a hash reference that can then be passed to the
`signature` function, e.g.

```perl
package Foo;

use Object::Signature::Portable ();

sub signature {
    my $self = shift;
    return Object::Signature::Portable::signature(
      data => $self->_serialize
    );
}

sub _serialize { # returns a hash reference of the object
   my $self = shift;
   ...
}
```

## Portability

The portability of signatures across different versions of
[JSON::MaybeXS](https://metacpan.org/pod/JSON%3A%3AMaybeXS) is, of course, dependent upon whether those versions
will produce consistent output.

If you are concerned about this, then write our own serializer, or
avoid upgrading [JSON::MaybeXS](https://metacpan.org/pod/JSON%3A%3AMaybeXS) until you are sure that the it will
produce consistent signatures.

## Security

This module is intended for generating signatures of Perl data
structures, as a simple means of determining whether two structures
are different.

For that purpose, the MD5 algorithm is probably good enough.  However,
if you are hashing data that in part comes from untrusted sources, or the
consequences of two different data structures having the same
signature are significant, then you should consider using a different
algorithm.

This module is _not_ intended for hashing passwords.

# SUPPORT FOR OLDER PERL VERSIONS

This module requires Perl v5.14 or later.

Future releases may only support Perl versions released in the last ten years.

# SEE ALSO

## Similar Modules

- [Object::Signature](https://metacpan.org/pod/Object%3A%3ASignature)

    This uses [Storable](https://metacpan.org/pod/Storable) to serialise objects and generate a MD5
    hexidecimal string as a signature.

    This has the drawback that machines with different architectures,
    different versions of Perl, or different versions [Storable](https://metacpan.org/pod/Storable), or in
    some cases different encodings of the same scalar, may not
    produce the same signature for the same data. (This does not mean that
    [Storable](https://metacpan.org/pod/Storable) is unable to de-serialize data produced by different
    versions; it only means that the serialized data is not identical
    across different versions.)

    [Object::Signature](https://metacpan.org/pod/Object%3A%3ASignature) does not allow for customizing the hash algorithm
    or signature format.

    [Object::Signature::Portable](https://metacpan.org/pod/Object%3A%3ASignature%3A%3APortable) module can replicate the signatures
    generated by [Object::Signature](https://metacpan.org/pod/Object%3A%3ASignature), using the following:

    ```perl
    use Storable 2.11;

    my $sig = signature(
      data       => $data,
      serializer => sub {
        local $Storable::canonical = 1;
        return Storable::nfreeze($_[0]);
      },
    );
    ```

    As noted above, using [Storable](https://metacpan.org/pod/Storable) will not produce portable
    signatures.

# SOURCE

The development version is on github at [https://github.com/robrwo/Object-Signature-Portable](https://github.com/robrwo/Object-Signature-Portable)
and may be cloned from [git://github.com/robrwo/Object-Signature-Portable.git](git://github.com/robrwo/Object-Signature-Portable.git)

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://github.com/robrwo/Object-Signature-Portable/issues](https://github.com/robrwo/Object-Signature-Portable/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

## Reporting Security Vulnerabilities

Security issues should not be reported on the bugtracker website.
Please see `SECURITY.md` for instructions how to report
security vulnerabilities

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

## Acknowledgements

Thanks to various people at YAPC::EU 2014 for suggestions about
[Sereal::Encoder](https://metacpan.org/pod/Sereal%3A%3AEncoder).

# CONTRIBUTOR

Slaven Rezić <slaven@rezic.de>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2013-2014, 2019-2024 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
