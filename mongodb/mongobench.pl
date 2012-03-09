#!/usr/bin/perl -w

# Load Module
use strict;
use warnings;
use utf8;
use Getopt::Std;
use Time::HiRes qw( sleep usleep ualarm gettimeofday tv_interval );
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

&main;

sub main {
my $time = localtime(time);
    print "StartTime          : $time\n";
#    print "タスク実行回数     : $TASKNUMBER\n";
    print "CONCURRENCY        : $CONCURRENCY\n";
#    print "タスク実行数/sec   : $PERSEC\n";
#    print "タスクの寿命(秒)   : $TASKLIFE\n";
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
        #threads->new(\&mongotest, $MAXREQUEST, $collection, $SLEEP)->join;
        threads->new(\&mongotest, $WRITEPERCENT, $MAXREQUEST, $collection, $SLEEP)->join;
    }

#    threads->new(\&speedControl, $queue, $PERSEC);
#    consumeQueue($queue, $CONCURRENCY, $TASKNUMBER, $TASKLIFE);
#    &quit;
$time = localtime(time);
    print "Endtime            : $time\n";
}


# sub routin
sub mongotest {
    my $writepercent = shift;
    my $maxrequest = shift;
    my $collection = shift;
    my $sleep = shift;
#    my $i = shift;
    my $randdata = 0;


    while($totalcnt < $maxrequest) {
#        print "TOTAL: $totalcnt\n";
#        print "WP: $writepercent\n";
#        print "RANDOM: $randdata\n";
        $randdata = int(rand(100));
        if( $writepercent > $randdata ) {
#            sleep ($sleep);
            &writedata($WRITEDATA, $collection, $maxrequest);
        }else {
#            sleep ($sleep);
            &readdata($collection, $maxrequest);
        }
        $totalcnt++;
    }
#    print "totalcnt: $totalcnt\n";
    return ($totalcnt);
}

sub writedata {
    my $writedata = shift;
    my $collection = shift;
    my $maxrequest = shift;
    my $writenum =  sprintf( "%010d", int(rand($maxrequest)));

#    print "update id: test${writenum} \n";
    my $t1 = (times)[0];
    #my $id   = $collection->update({"_id" => "test${writenum}", foo => $writedata, bar => $writedata, baz => $writedata, hoge => $writedata, fuga => $writedata});
    my $id   = $collection->update({"_id" => "test${writenum}"}, {'$set' => {foo => $writedata, bar => $writedata, baz => $writedata, hoge => $writedata, fuga => $writedata}});
    my $t2 = (times)[0];
    my $t3 = $t2 - $t1;
    my $t3 =  sprintf( "%f", $t3);
    print "update :" .  sprintf( "%f", $t3) . "\n";

#    print "Write $writedata\n";
    return ;
}

sub readdata {
    my $collection = shift;
    my $maxrequest = shift;
    my $readnum =  sprintf( "%010d", int(rand($maxrequest)));


#    print "find id: test${readnum} \n";
    my $t1 = (times)[0];
    my $data = $collection->find_one({"_id" => "test${readnum}" });
    my $t2 = (times)[0];
    my $t3 = $t2 - $t1;
    print "find :" .  sprintf( "%f", $t3) . "\n";

#    print "Write $writedata\n";
    return ;
}

sub deletefile {
}

sub rewritefile {
}

## 終了処理
#sub quit {
#    #永続スレッド(speedControl)に終了の合図を送る
#    $alerm = 1;
#    #全てのスレッドが終了するのを待機する
#    foreach my $thr (threads->list) {
#        if ($thr->tid && !threads::equal($thr, threads->self)) {
#            $thr->join;
#        }
#    }
#    exit 0;
#}
