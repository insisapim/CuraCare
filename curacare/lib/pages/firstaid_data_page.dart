import 'package:flutter/material.dart';
import 'package:curacare/models/firstaiddata.dart';
import 'package:curacare/models/firstaidmockdata.dart';

class FirstaidDataPage extends StatelessWidget {
  final FirstaidData data;

  const FirstaidDataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final stepSection = data.sections.firstWhere(
      (s) => s.type == FirstaidSectionType.step,
    );

    final warningSection = data.sections.firstWhere(
      (s) => s.type == FirstaidSectionType.warning,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("คู่มือปฐมพยาบาล", style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderCard(data),
            _StepCard(stepSection),
            _WarningCard(warningSection),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final FirstaidData data;
  const _HeaderCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.favorite, color: Colors.white),
        ),
        title: Text(
          data.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(data.description),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final FirstaidSection section;
  const _StepCard(this.section);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...section.items.map((e) {
              final step = e as FirstaidStep;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    step.order.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(step.text),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final FirstaidSection section;
  const _WarningCard(this.section);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...section.items.map((e) {
              final warn = e as FirstaidWarn;
              return ListTile(
                leading: const Icon(Icons.warning_rounded, color: Colors.red),
                title: Text(warn.text),
              );
            }),
          ],
        ),
      ),
    );
  }
}
