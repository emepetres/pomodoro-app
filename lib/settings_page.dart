import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Padding(
      padding: const EdgeInsets.all(38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pomodoro Duration",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: appState.pomodoroDuration.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 59,
                          label: '${appState.pomodoroDuration} minutes',
                          onChanged: (value) {
                            appState.setPomodoroDuration(value.toInt());
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${appState.pomodoroDuration} min',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Timer Sound",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: appState.selectedSound,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'alarm.wav',
                        child: Text('Alarm'),
                      ),
                      DropdownMenuItem(
                        value: 'rain-rainforest.mp3',
                        child: Text('Rain Rainforest'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        appState.setSelectedSound(newValue);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
