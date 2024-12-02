This is the Security Policy for the Perl 5 distribution Object-Signature-Portable.

The latest version of this Security Policy can be found at
<https://metacpan.org/dist/Object-Signature-Portable>.

This text is based on the CPAN Security Group's Guidelines for Adding
a Security Policy <https://security.metacpan.org/docs> (v0.1.4).

# How to Report a Security Vulnerability

Security vulnerabilties can be reported by e-mail to the current
project maintainer(s) at <rrwo@cpan.org>.

Please include as many details as possible, including code samples, so
that we can reproduce the issue.

If this is a 0-day vulnerability that is actively being exploited,
then please copy the report to the CPAN Security Group (CPANSec) at
<cpan-security@security.metacpan.org>.

Please *do not* use the public issue reporting system on RT or GitHub
issues for reporting security vulnerabilities.

Please do not disclose the security vulnerability before it has been
made public by the maintainers or CPANSec.  That includes blogs,
social media, forums, or conferences.

## Response to Reports

The maintainer(s) aim to acknowledge your security report as soon as
possible.  However, this project is maintained by a single person in
their spare time, and they cannot guarantee a rapid response.  If you
have not received a response from them within a week, then please send
a reminder to them and copy the report to CPANSec at
<cpan-security@security.metacpan.org>.

Note that the initial response to your report will be an
acknowledgement, with a possible query for more information.  It will
not necessarily include any fixes for the issue.

The project maintainer(s) may forward this issue to the security
contacts for other projects where we believe it is relevant.  This may
include embedded libraries or prerequisite modules or system
libraries, or downstream software that uses this software.

They may also forward this issue to the CPANSec if they have not
already been copied on this.

# What Software this Policy Applies to

Any security vulnerabilities in Object-Signature-Portable are covered
by this policy.

Security vulnerabilities are considered anything that allows users to
execute unauthorised code, access unauthorised resources, or to have
an adverse impact on accessibility or performance of a system.

Security vulnerabilities in upstream software (embedded libraries,
prerequisite modules or system libraries, or in Perl), are not
convered by this policy.

Security vulnerabilities in downstream software (any software that
uses Object-Signature-Portable, or plugins to it that are not included with the
Object-Signature-Portable distribution) are not covered by this
policy.

However, vulnerabilities in upstream software that can affect
Object-Signature-Portable, or where Object-Signature-Portable can be
used to exploit vulnerabilities in other software (upstream or
downstream), are considered vulnerabilities of
Object-Signature-Portable, and are covered by this policy.

## Which Versions of this Software are Supported?

The maintainer(s) will only commit to releasing security fixes for the
latest version of Object-Signature-Portable.

Note that the Object-Signature-Portable project only supports major
versions of Perl released in the past ten (10) years, even though
Object-Signature-Portable will run on older versions of Perl.  If a
security fix requires us to increase the minimum version of Perl that
is supported, then we may do that.

# Installation and Usage Issues

The distribution metadata specifies minimum versions of prerequisites
that are required for Object-Signature-Portable to work.  However,
some of these prerequisites may have security vulnerabilities, and you
should ensure that you are using up-to-date versions of these
prerequisites.

Where security vulnerabilities are known, the metadata may indicate
newer versions as recommended.

## Usage

This software defaults to using the MD5 algorithm for generaing a
signature of data structures. In most cases this should be good enough
for detecting changes to data structures.  However, MD5 is no longer
considered a secure alghorithm for cryptographic signatures.  If you
need something more secure, then you will need to change the default.

See the LIMITATIONS section of the module documentation for more
information.
