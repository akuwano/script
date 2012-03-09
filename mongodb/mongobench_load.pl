#!/usr/bin/perl -w

# Load Module
use strict;
use warnings;
use utf8;
use Getopt::Std;
use Time::HiRes qw( usleep ualarm gettimeofday tv_interval );
use threads;
use threads::shared;
use Thread::Semaphore;
use Thread::Queue;
use MongoDB;


# Init
my %opts;
#getopts ("e:c:t:l:p:", \%opts);
getopts ("c:s:r:w:b:h:d:t:p:", \%opts);
#my $TASKNUMBER    = $opts{'e'} || 10;  #タスク実行回数
my $CONCURRENCY       = $opts{'c'} || 4;   #タスク実行の並列度
#my $PERSEC        = $opts{'t'} || 0.5; #タスク実行数/sec
#my $TASKLIFE      = $opts{'l'} || 5;   #タスクの寿命(秒)
my $SLEEP             = $opts{'s'} || 0.1;   #sleep
my $MAXREQUEST        = $opts{'r'} || 10;    #100000000
my $WRITEPERCENT      = $opts{'w'} || 0;
my $WRITEBYTE         = $opts{'b'} || 10;
my $HOST              = $opts{'h'} || 'localhost';   #
my $DATABASE          = $opts{'d'} || 'testdb';   #
my $COL               = $opts{'t'} || 'testcol';   #
my $PORT              = $opts{'p'} || 27017;   #
my $FILENUM   :shared = 5000;
my $WRITEDATA :shared = "R" x $WRITEBYTE;
my $s_cnt             = new Thread::Semaphore;
my $totalcnt :shared  = 0;
my $alerm :shared     = 0;          #終了の合図

# PackageName
package MongoBench;

# Main
&main;

sub main {
my $time = localtime(time);
    print "StartTime          : $time\n";
    print "CONCURRENCY        : $CONCURRENCY\n";
    print "MAXREQUEST         : $MAXREQUEST\n";
    print "WRITEPERCENT       : $WRITEPERCENT\n";
    print "WRITEBYTE          : $WRITEBYTE\n";
    print "HOST               : $HOST\n";
    print "PORT               : $PORT\n";
    print "DATABASE           : $DATABASE\n";
    print "COL                : $COL\n";
    print "SLEEPTIME          : $SLEEP\n";
    my $queue = Thread::Queue->new;

    my $connection = MongoDB::Connection->new(host => $HOST, port => $PORT);
    my $db         = $connection->$DATABASE;
    my $collection = $db->$COL;

    for(my $i = 0; $i < $CONCURRENCY; $i++) {
        ##my $thread =  threads->new(\&filetest, $WRITEPERCENT, $MAXREQUEST)->join;
        #threads->new(\&filetest, $WRITEPERCENT, $MAXREQUEST, $DATABASE, $SLEEP)->join;
        threads->new(\&mongotest, $MAXREQUEST, $collection, $SLEEP)->join;
    }

#    threads->new(\&speedControl, $queue, $PERSEC);
#    consumeQueue($queue, $CONCURRENCY, $TASKNUMBER, $TASKLIFE);
#    &quit;
my $time = localtime(time);
    print "Endtime            : $time\n";
}


# sub routin
sub mongotest {
    my $maxrequest = shift;
    my $collection = shift;
    my $sleep = shift;
#    my $i = shift;
    my $randdata = 0;

    while($totalcnt < $maxrequest) {
#        print "TOTAL: $totalcnt\n";
#        print "WP: $writepercent\n";
#        print "RANDOM: $randdata\n";
        &writedata($WRITEDATA,$collection);
        $totalcnt++;
    }
#    print "totalcnt: $totalcnt\n";
    return ($totalcnt);
}

sub writedata {
    my $writedata = shift;
    my $collection = shift;
    my $writenum = sprintf( "%010d", $totalcnt);

    my $id   = $collection->insert({"_id" => "test${writenum}", foo => $writedata, bar => $writedata, baz => $writedata, hoge => $writedata, fuga => $writedata});


#    print "Write $writedata\n";
    return ;
}

