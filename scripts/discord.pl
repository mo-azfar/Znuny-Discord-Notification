#!/usr/bin/env perl
# --
#REF: https://discord.com/developers/docs/getting-started#step-1-creating-an-app
#REF2: https://stackoverflow.com/questions/68701824/using-discord-api-curl-to-send-a-discord-dm
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new();

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my %List = $UserObject->UserList(
    Type          => 'Long', # Short|Long, default Short
    Valid         => 1,       # default 1
);


delete $List{1};
print "List of Agents : \n\n";
print "Znuny UserID		Name\n";
foreach my $User (keys %List)
{
	print "$User			$List{$User}";
	print "\n";
}

print "\nSELECT AGENT BY Znuny UserID: ";
my $agent = <STDIN>;
chomp $agent;

if(exists($List{$agent}))
{
	print "INSERT Discord User ID for $List{$agent}: ";
	my $agent_discord_id = <STDIN>;
	chomp $agent_discord_id;
	
	print "\nOpening Discord Channel Between bot and Discord User ID...\n";
	my $URL = "https://discord.com/api/v10/users/\@me/channels";
	my $params = {
		'recipient_id'      => $agent_discord_id,
	};
	
	use LWP::UserAgent;	
	my $ua = LWP::UserAgent->new;
	use JSON::MaybeXS;
	
	my $response = $ua->post( $URL, 
		Authorization => 'Bot <DISCORD_BOT_TOKEN>',
		User_Agent => 'DiscordBot',
		Content_Type    => 'application/json',
		Content         => JSON::MaybeXS::encode_json($params) 
	);
	
	my $content  = $response->decoded_content();
	my $resCode =$response->code();
	my $j = decode_json($content);
	
	print ".........\n";
	if ($resCode ne 200)
	{
		print "$j->{message}\n\n";
		exit;
	}
	
	print "Discord Channel ID for $List{$agent}: $j->{id}\n";
	print ".........\n";
	print "Updating Agent $List{$agent} Preferences with Discord Channel ID\n";
	
	$UserObject->SetPreferences(
        Key    => 'UserDiscordChannelID',
        Value  => $j->{id},
        UserID => $agent,
    );
	
	print ".........\n";
	print "Done\n\n";
}
else
{
    print "\nNot Exists\n";
	exit;
}
