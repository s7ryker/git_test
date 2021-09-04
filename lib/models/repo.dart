class Repo {
  String name;
  String htmlUrl; // hmtl_url
  int starCount; //star_count

  Repo({
    required this.name,
    required this.htmlUrl,
    required this.starCount,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      htmlUrl: json['html_url'],
      starCount: json['stargazers_count'],
    );
  }
}

class All {
  List<Repo> repos;

  All({required this.repos});

  factory All.fromJson(List<dynamic> json) {
    List<Repo> repos = [];
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos: repos);
  }
}
