#!@perl@ -w
# Copyright (C) 2014-2019 all contributors <meta@public-inbox.org>
# License: GPL-3.0+ <https://www.gnu.org/licenses/gpl-3.0.txt>
use strict;
use PublicInbox::WWW;
use Plack::Builder;

my $www = PublicInbox::WWW->new;
$www->preload;

builder {
  enable 'Head';
  enable 'ReverseProxy';
  mount q(@path@) => sub { $www->call(@_) };
}

