#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Net::Google::Calendar;
use DateTime;  
use Encode;

my $username = 'username';
my $password = 'passwd';

my $calendar = Net::Google::Calendar->new;
my $return =  $calendar->login( $username, $password );
die "login error:" if !defined $return;
say "登陆成功";

my $wsn_calendar;
foreach my $c ($calendar->get_calendars)
{
    #查询标题为"WSN"的Calendar
    if($c->title =~ /dio/i)
    {
        $wsn_calendar = $c;
    }
}
die "$wsn_calendar is null." if !defined $wsn_calendar;
say "获取calendar成功";

#设置当前的Calendar
$calendar->set_calendar($wsn_calendar);

my $entry = Net::Google::Calendar::Entry->new();
my $title = "ddd is dead";

#用decode转换为UTF-8编码
$entry->title(decode("utf-8",$title));
my $event_descrip = "yeah";

$entry->content(decode("utf-8",$event_descrip));

#两个参数都是DateTime类型，第一个是待办事件的开始时间，第二个是结束时间。这里设置为10分钟后开始，15分钟后结束
$entry->when(DateTime->now(time_zone=>'local') + DateTime::Duration->new( minutes => 1 ),
             DateTime->now(time_zone=>'local') + DateTime::Duration->new( minutes => 2 ));

my $event = $calendar->add_entry($entry);
die "add_entry error." if !defined $event;
say "添加events成功";

#这里添加提醒，将提醒时间设置为待办事件开始前的5分钟
$event->reminder('sms','minutes','1');
$return = $calendar->update_entry($event);
die "update_entry error." if !defined $return;
say "添加SMS reminder 成功";
