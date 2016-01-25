package Mojo::Weixin::Friend;
use Mojo::Weixin::Base 'Mojo::Weixin::Model::Base';
has name => '昵称未知';
has [qw( 
    account
    province
    city
    sex
    id
    signature
    display
    markname
)];

sub displayname{
    my $self = shift;
    return $self->display || $self->markname || $self->name;
}

sub update{
    my $self = shift;
    my $hash = shift;
    for(grep {substr($_,0,1) ne "_"} keys %$self){
        if(exists $hash->{$_}){
            if(defined $hash->{$_} and defined $self->{$_}){
                if($hash->{$_} ne $self->{$_}){
                    my $old_property = $self->{$_};
                    my $new_property = $hash->{$_};
                    $self->{$_} = $hash->{$_};
                    $self->client->emit("friend_property_change"=>$self,$_,$old_property,$new_property) if defined $self->client;
                }
            }
            elsif( ! (!defined $hash->{$_} and !defined $self->{$_}) ){
                my $old_property = $self->{$_};
                my $new_property = $hash->{$_};
                $self->{$_} = $hash->{$_};
                $self->client->emit("friend_property_change"=>$self,$_,$old_property,$new_property) if defined $self->client;
            }
        }
    }
    $self;

}

sub send{
    my $self = shift;
    $self->client->send_message($self,@_);
}
1;