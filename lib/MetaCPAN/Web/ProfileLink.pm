package MetaCPAN::Web::ProfileLink;
use Moose;

use URI::Escape qw( uri_escape );

has name => (
    is       => 'ro',
    required => 1,
);

has label => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $name = $self->name;
        ucfirst $name;
    },
);

has rule => (
    is      => 'ro',
    default => '(.*)',
);

has rule_re => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $rule = $self->rule;
        qr/$rule/;
    },
);

has icon => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $name = $self->name;
        "/static/images/profile/$name.png";
    },
);

has url_format => (
    is       => 'ro',
    required => 1,
);

sub BUILD {
    my $self = shift;
    $self->label;
    $self->rule_re;
    $self->icon;
}

sub url_for {
    my $self       = shift;
    my $id         = shift;
    my $rule_re    = $self->rule_re;
    my $url_format = $self->url_format;

    my @parts = $id =~ $rule_re
        or return undef;
    no warnings 'redundant';
    sprintf $url_format, map uri_escape($_), @parts;
}

__PACKAGE__->meta->make_immutable;

1;
