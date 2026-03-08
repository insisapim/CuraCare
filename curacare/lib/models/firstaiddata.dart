class FirstaidData {
  final String title;
  final String description;
  final List<FirstaidSection> sections;

  FirstaidData({
    required this.title,
    required this.description,
    required this.sections,
  });
}


class FirstaidStep{
  final int order;
  final String text;
  FirstaidStep({
    required this.order,
    required this.text
  });
}

class FirstaidWarn{
  final String text;
  FirstaidWarn({
    required this.text
  });
}

enum FirstaidSectionType  { step , warning}

class FirstaidSection{
  final String title;
  final FirstaidSectionType type;
  final List<dynamic> items;

  FirstaidSection({
    required this.title,
    required this.type,
    required this.items 
  });
}