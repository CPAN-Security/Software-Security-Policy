use strict;
use warnings;
package Software::Security::Policy;
# ABSTRACT: packages that provide templated Security Policies

# VERSION

=head1 SYNOPSIS

  use strict;
  use warnings;

  use Software::Security::Policy::Individual;

  my $policy = Software::Security::Policy::Individual->new({
    maintainer  => 'Timothy Legge <timlegge@gmail.com>',
    program     => 'Software::Security::Policy',
    timeframe   => '7 days',
    url         => 'https://github.com/CPAN-Security/Software-Security-Policy/blob/main/SECURITY.md',
    perl_support_years   => '10',
  });

  print $policy->fulltext, "\n";

=head1 DESCRIPTION

This is a framework for generating a SECURITY.md file to your Perl distributions that will let people know:

=over 4

=item 1. How to contact the maintainers if they find a security issue with your software

=item 2. What software will be supported for security issues

=back

The contact point is very important for modules that have been around for a long time and have had several authors over the years. When there is a long list of maintainers, it's not clear who to contact.

You don't want people reporting security vulnerabilities in public on the RT or GitHub issues for your project, nor do you want a post on IRC, Reddit or social media about it.

If your software is on GitHub, you can set up L<private vulnerability|https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/configuring-private-vulnerability-reporting-for-a-repository> reporting. GitLab has a similar system.

Otherwise, a single email address is acceptable. An alias that forwards to all of the maintainers or at the very least, a single maintainer who has agreed to that role will work.

It's also important to realise as a maintainer that you are not on your own when you receive a vulnerability report. You are welcome and even encouraged to reach out to CPANSec for assistance triaging and fixing the issue, as well as handling notifications and reporting.

The supported software version may seem obvious, but it's important to spell out: will you be updating only the latest version? What versions of Perl will you support? If your module uses or embeds other libraries, how will they be supported?

=attr program

the name of software for use in the middle of a sentence

=attr Program

the name of software for use in the beginning of a sentence

C<program> and C<Program> arguments may be specified both, either one or none.
Each argument, if not specified, is defaulted to another one, or to properly
capitalized "this program", if both arguments are omitted.

=method summary

This method returns a snippet of text, usually a few lines, indicating the
maintainer as well as an indication of the policy under which the software
is maintained.

=method security_policy

This method returns the full text of the policy.

=method fulltext

This method returns the complete text of the policy (summary and policy).

=method name

This method returns the name of the policy, suitable for shoving in the middle
of a sentence, generally with a leading capitalized "The."

=cut

sub name {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/^Software::Security::Policy:://;
  $pkg =~ s/::/ /g;
  return $pkg;
}

=method version

This method returns the version of the policy.  If the security
policy is not versioned, this method will return undef.

=cut

sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;

  return unless @vparts;
  return join '.', @vparts;
}

=head1 ACKNOWLEDGMENT

This module is based extensively on Software::License.

=cut

=head1 SEE ALSO

The specific policy:

=for :list
* L<Software::Security::Policy::Individual>

Extra policies are maintained on CPAN in separate modules.

=cut

1;
