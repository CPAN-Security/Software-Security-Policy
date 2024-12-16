use strict;
use warnings;
package Software::Security::Policy;
# ABSTRACT: packages that provide templated Security Policys

# VERSION

use Data::Section -setup => { header_re => qr/\A__([^_]+)__\Z/ };
use Text::Template ();

=head1 SYNOPSIS

  my $policy = Software::Security::Policy::SingleDeveloper->new({
    maintainer => 'Timothy Legge',
  });

  print $output_fh $policy->fulltext;

=method new

  my $policy = $subclass->new(\%arg);

This method returns a new security policy object for the given
security policy class.  Valid arguments are:

=for :list
= maintainer
the current maintainer for the distibrution; required
= program
the name of software for use in the middle of a sentence
= Program
the name of software for use in the beginning of a sentence

C<program> and C<Program> arguments may be specified both, either one or none.
Each argument, if not specified, is defaulted to another one, or to properly
capitalized "this program", if both arguments are omitted.

=cut

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no maintainer is specified" unless $arg->{maintainer};

  bless $arg => $class;
}

=method support_years

=method timeframe

=method maintainer

These methods are attribute readers.

=cut

sub support_years { $_[0]->{support_years} || '10'}

sub timeframe { $_[0]->{timeframe} || '5 days'    }

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

This method returns the version of the policy.  If the security policy is not
versioned, this method will return false.

=cut

sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;

  return unless @vparts;
  return join '.', @vparts;
}

=method meta_name

This method returns the string that should be used for this security policy in the CPAN
META.yml file, according to the CPAN Meta spec v1, or undef if there is no
known string to use.

=method meta2_name

This method returns the string that should be used for this security policy in the CPAN
META.json or META.yml file, according to the CPAN Meta spec v2, or undef if
there is no known string to use.  If this method does not exist, and
C<meta_name> returns open_source, restricted, unrestricted, or unknown, that
value will be used.

=cut

# sub meta1_name    { return undef; } # sort this out later, should be easy
sub meta_name     { return undef; }

# FIXME : are there any meta attributes for this?
sub meta2_name {
  my ($self) = @_;
  my $meta1 = $self->meta_name;

  return undef unless defined $meta1;

  return $meta1
    if $meta1 =~ /\A(?:open_source|restricted|unrestricted|unknown)\z/;

  return undef;
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

=head1 LOOKING UP LICENSE CLASSES

FIXME: Remove - unneeded
If you have an entry in a F<META.yml> or F<META.json> file, or similar
metadata, and want to look up the Software::Security::Policy class to use, there are
useful tools in L<Software::Security::Policy::Utils>.

=head1 TODO

=for :list
* register policys with aliases to allow $registry->get('gpl', 2);

=head1 SEE ALSO

The specific policy:

=for :list
* L<Software::Security::Policy::Individual>

Extra policys are maintained on CPAN in separate modules.

FIXME Remove
The L<App::Software::Security::Policy> module comes with a script
L<software-policy|https://metacpan.org/pod/distribution/App-Software-Security::Policy/script/software-policy>,
which provides a command-line interface to Software::Security::Policy.

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
