package MetaCPAN::Web::Model::API::CVE;
use Moose;
extends 'MetaCPAN::Web::Model::API';

sub get {
    my ( $self, $author, $release ) = @_;
    $self->request("/cve/release/$author/$release")->then( sub {
        my $data = shift;
        Future->done( { cves => $data->{cve} || [] } );
    } );
}

__PACKAGE__->meta->make_immutable;
1;
