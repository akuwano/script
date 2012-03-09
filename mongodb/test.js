use admin
config = {
_id: 'RSPiggIsland004',
members: [
{_id: 0, host: '10.200.1.10:27218', priority:2},
{_id: 1, host: '10.200.1.11:27218', priority:1},
{_id: 2, host: '10.200.1.12:27218', priority:0}]
}
rs.initiate(config)


