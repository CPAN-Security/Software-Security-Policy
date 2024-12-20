use strict;
use warnings;
package Software::Security::Policy;
# ABSTRACT: packages that provide templated Security Policys

# VERSION

use Data::Section -setup => { header_re => qr/\A__([^_]+)__\Z/ };
use Text::Template ();

=head1 SYNOPSIS

  my $policy = Software::Security::Policy::Individual->new({
    maintainer => 'security@example.com',
  });

  print $output_fh $policy->fulltext;

=head1 METHODS

=over

=item new

  my $policy = $subclass->new(\%arg);

This method returns a new security policy object for the given
security policy class.  Valid arguments are:

=back

=head2 ATTRIBUTES

=over

=item maintainer

the current maintainer for the distibrution; required

=item timeframe

the time to expect acknowledgement of a security issue.  Should
include the units such as '5 days or 2 weeks'; defaults to 5 days

=item timeframe_quantity

the amount of time to expect an acknowledgement of a security issue.
Only used if timeframe is undefined and timeframe_units is defined
(eg. '5')

=item timeframe_units

the units of time to expect an acknowledgement of a security issue.
Only used if timeframe is undefined and timeframe_quantity is defined
(eg. 'days')

=item url

a url where the most current security policy can be found.

=item support_years

the number of years for which past major versions of Perl would be
supported

=item program

the name of software for use in the middle of a sentence

=item Program

the name of software for use in the beginning of a sentence

C<program> and C<Program> arguments may be specified both, either one or none.
Each argument, if not specified, is defaulted to another one, or to properly
capitalized "this program", if both arguments are omitted.

=back

=cut

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no maintainer is specified" unless $arg->{maintainer};

  bless $arg => $class;
}

=method support_years

Get the number of years of support to be expected

=method timeframe

Get the expected response time. Defaults to 5 days and uses
timeframe_quantity and timeframe_units if the timeframe attribute
us undefined.

=method maintainer

Get the maintainer that should be contacted for security issues.

=method url

Get the URL of the latest security policy version.

These methods are attribute readers.

=cut

sub url { $_[0]->{url} || 'SECURITY.md' }

sub support_years { $_[0]->{support_years} || '10'}

sub timeframe {
    return $_[0]->{timeframe} if defined $_[0]->{timeframe};
    return $_[0]->{timeframe_quantity} . ' ' . $_[0]->{timeframe_units}
        if defined $_[0]->{timeframe_quantity} &&
            defined $_[0]->{timeframe_units};
    return '5 days';
}

sub maintainer { $_[0]->{maintainer}     }

sub _dotless_maintainer {
  my $maintainer = $_[0]->maintainer;
  $maintainer =~ s/\.$//;
  return $maintainer;
}

=method program

Name of software for using in the middle of a sentence.

The method returns value of C<program> constructor argument (if it evaluates as true, i. e.
defined, non-empty, non-zero), or value of C<Program> constructor argument (if it is true), or
"this program" as the last resort.

=cut

sub program { $_[0]->{program} || $_[0]->{Program} || 'this program' }

=method Program

Name of software for using at the beginning of a sentence.

The method returns value of C<Program> constructor argument (if it is true), or value of C<program>
constructor argument (if it is true), or "This program" as the last resort.

=cut

sub Program { $_[0]->{Program} || $_[0]->{program} || 'This program' }

=method name

This method returns the name of the policy, suitable for shoving in the middle
of a sentence, generally with a leading capitalized "The."

=method url

This method returns the URL at which a canonical text of the security policy can be
found, if one is available.  If possible, this will point at plain text, but it
may point to an HTML resource.

=method summary

This method returns a snippet of text, usually a few lines, indicating the
maintainer as well as an indication of the policy under which the software
is maintained.

=cut

sub summary { shift->_fill_in('SUMMARY') }

=method security_policy

This method returns the full text of the policy.

=cut

sub security_policy { shift->_fill_in('SECURITY-POLICY') }

=method fulltext

This method returns the complete text of the policy.

=cut

sub fulltext {
  my ($self) = @_;
  return join "\n", $self->summary, $self->security_policy;
}

=method version

This method returns the version of the policy.  If the security
policy is not versioned, this method will return false.

=cut

sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;

  return unless @vparts;
  return join '.', @vparts;
}

sub _fill_in {
  my ($self, $which) = @_;

  Carp::confess "couldn't build $which section" unless
    my $template = $self->section_data($which);

  return Text::Template->fill_this_in(
    $$template,
    HASH => { self => \$self },
    DELIMITERS => [ qw({{ }}) ],
  );
}

=head1 SEE ALSO

The specific policy:

=for :list
* L<Software::Security::Policy::Individual>

Extra policys are maintained on CPAN in separate modules.

=head1 COPYRIGHT

This module is based extensively on Software::License.  Only the
changes required for this module are attributable to the author of
this module.  All other code is attributable to the author of
Software::License.

=cut

1;

__DATA__
__SUMMARY__
This is the Security Policy for the {{ $self->program }} distribution.

Report issues to:

  {{ $self->maintainer }}
