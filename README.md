# NAME

Object::Signature::Portable - generate portable fingerprints of objects

# VERSION

version v0.2.1

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

    The cryptographic digest algorithm, as supported by [Crypt::Digest](https://metacpan.org/pod/Crypt::Digest).

- `format`

    The [Crypt::Digest](https://metacpan.org/pod/Crypt::Digest) formatting method for the signature, which can be
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
    [Data::Dumper](https://metacpan.org/pod/Data::Dumper) or [Sereal::Encoder](https://metacpan.org/pod/Sereal::Encoder) should be acceptable
    alternatives, provided that you enable canonical encoding, and in the
    case of Sereal, explicitly specify a protocol version.)

    By default, it uses [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS). The choice for using JSON is
    based on the following considerations:

    - JSON is a simple, text-based format. The output is not likely to
    change between module versions.
    - Classes can be extended with hooks for JSON serialization.
    - Speed is not a factor.

    However, see ["LIMITATIONS"](#limitations) below.

# LIMITATIONS

## Signatures for Arbitrary Objects

By default, this module uses [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) to serialize Perl objects.

This requires the objects to have a `TO_JSON` method in order to be
serialized.  Unfortunately, this is not suitable for many objects
(particularly those generated by modules that are not under your
control, e.g. many CPAN modules) without monkey-patching or
subclassesing them.

One solution is to use a different serializer that can handle the
object.

Alternatively, you can write a wrapper function that uses a module
such as [Object::Serializer](https://metacpan.org/pod/Object::Serializer) to translate an object into a hash
reference that can then be passed to the `signature` function, e.g.

```perl
package Foo;

use parent 'Object::Serializer';

use Object::Signature::Portable ();

sub signature {
    my $self = shift;
    return Object::Signature::Portable::signature(
      data => $self->serialize
    );
}
```

Note that [Object::Serializer](https://metacpan.org/pod/Object::Serializer) allows you to define custom
serialization strategies for various reference types.

## Portability

The portability of signatures across different versions of
[JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) is, of course, dependent upon whether those versions
will produce consistent output.

If you are concerned about this, then write our own serializer, or
avoid upgrading [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) until you are sure that the it will
produce consistent signatures.

## Security

This module is intended for generating signatures of Perl data
structures, as a simple means of determining whether two structures
are different.

For that purpose, the MD5 algorithm is probably good enough.  However,
if you are hashing that in part comes from untrusted sources, or the
consequences of two different data structures having the same
signature are significant, then you should consider using a different
algorithm.

This module is _not_ intended for hashing passwords.

# SEE ALSO

## Similar Modules

- [Object::Signature](https://metacpan.org/pod/Object::Signature)

    This uses [Storable](https://metacpan.org/pod/Storable) to serialise objects and generate a MD5
    hexidecimal string as a signature.

    This has the drawback that machines with different architectures,
    different versions of Perl, or different versions [Storable](https://metacpan.org/pod/Storable) may not
    produce the same signature for the same data. (This does not mean that
    [Storable](https://metacpan.org/pod/Storable) is unable to de-serialize data produced by different
    versions; it only means that the serialized data is not identical
    across different versions.)

    [Object::Signature](https://metacpan.org/pod/Object::Signature) does not allow for customizing the hash algorithm
    or signature format.

    [Object::Signature::Portable](https://metacpan.org/pod/Object::Signature::Portable) module can replicate the signatures
    generated by [Object::Signature](https://metacpan.org/pod/Object::Signature), using the following:

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

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

## Acknowledgements

Thanks to various people at YAPC::EU 2014 for suggestions about
[Sereal::Encoder](https://metacpan.org/pod/Sereal::Encoder).

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2013-2014, 2019-2020 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
