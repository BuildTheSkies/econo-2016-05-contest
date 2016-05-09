use strict;
use 5.010;
use TheGameCrafter::Client;
use DateTime;
use Config::JSON;

# settings
my $config = Config::JSON->new('config.json');

# create session
say "Creating session";
my $session = tgc_post('session',[
     username    => $ENV{TGC_USER},
     password    => $ENV{TGC_PASS},
     api_key_id  => $ENV{TGC_API_KEY},
]);

# delete old cards
#my $deck_id = $config->get('deck_id');
#say "Deleting old cards";
#my $cards = tgc_get('/api/pokerdeck/'.$deck_id.'/cards',{session_id => $session->{id}, _items_per_page => 100});
#foreach my $card (@{$cards->{items}}) {
#    tgc_delete('pokercard/'.$card->{id}, [ 
#        session_id  => $session->{id},
#    ]);
#    sleep 1;
#}


# delete old files 
my $folder_id = $config->get('folder_id');
#say "Deleting old files";
#my $files = tgc_get('/api/folder/'.$folder_id.'/files',{session_id => $session->{id}, _items_per_page => 100});
#foreach my $file (@{$files->{items}}) {
#    tgc_delete('file/'.$file->{id}, [ 
#        session_id  => $session->{id},
#    ]);
#    sleep 1;
#}



# create tiles 
my $out_path = $config->get('out');
say "Creating tiles";
foreach my $tile_config (@{$config->get('components')}) {
    say $tile_config->{name};
    say "Uploading face";
    my $face = tgc_post('file',[
        name        => $tile_config->{name},
        folder_id   => $folder_id,
        file        => [$out_path .'/'. $tile_config->{name}.'-face.png'],
        session_id  => $session->{id},
    ]);
    say "Uploading back";
    my $back = tgc_post('file',[
        name        => $tile_config->{name}.'-back',
        folder_id   => $folder_id,
        file        => [$out_path .'/'. $tile_config->{name}.'-back.png'],
        session_id  => $session->{id},
    ]);
    say "Creating tile";
    my $card = tgc_post('minihextile', [
        game_id             => $config->get('game_id'),
        name                => $tile_config->{name},
        quantity            => $tile_config->{quantity},
        session_id          => $session->{id},
        face_id             => $face->{id},
        back_id             => $back->{id},
        has_proofed_face    => 1,
        has_proofed_back    => 1,
    ]);
    sleep 1;
}

say "All done!";

