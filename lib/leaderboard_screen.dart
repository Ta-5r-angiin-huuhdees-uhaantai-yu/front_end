import 'package:bd_frontend/bloc/leaderboard_bloc.dart';
import 'package:bd_frontend/model/api_service.dart';
import 'package:bd_frontend/widgets/full_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/leaderboard_response.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final LeaderboardBloc _bloc;

  List<LeaderItem> userList = [];

  @override
  void initState() {
    super.initState();
    _bloc = LeaderboardBloc(ApiService());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaderboardBloc>(
      create: (context) => _bloc..add(FetchUserAllInfo()),
      child: BlocListener<LeaderboardBloc, LeaderboardState>(
        listener: _blocListener,
        child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, LeaderboardState state) async {
    fullLoader(state is LeaderboardLoading);
    if (state is LeaderboardSuccess) {
      setState(() {
        userList = state.data ?? [];
        print('eeeeeeeeeeee${userList}');
      });
    } else if (state is LeaderboardFailure) {}
  }

  Widget _blocBuilder(BuildContext context, LeaderboardState state) {
    final users = userList;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Leaderboard"),
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${user.rank}.",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  if (user.rank == 1)
                    const Icon(Icons.emoji_events,
                        color: Colors.amber, size: 24)
                  else if (user.rank == 2)
                    const Icon(Icons.emoji_events,
                        color: Colors.grey, size: 24)
                  else if (user.rank == 3)
                    const Icon(Icons.emoji_events,
                        color: Colors.brown, size: 24)
                  else
                    const Icon(Icons.star_border,
                        color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                ],
              ),
              title: Text(
                user.login_name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              trailing: Text(
                user.totalPoints.toStringAsFixed(0),
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          );
        },
      ),
    );
  }
}
