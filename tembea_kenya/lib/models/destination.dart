class Destination {
  final String title;
  final String about;
  final String imageurl;
  final String noofreviews;
  final String review;
  final String summary;
  final String wikipediaurl;

  Destination({
    this.title,
    this.about,
    this.imageurl,
    this.noofreviews,
    this.review,
    this.summary,
    this.wikipediaurl,
  });

  Destination.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        imageurl = json['imageurl'],
        noofreviews = json['noofreviews'],
        review = json['review'],
        summary = json['summary'],
        wikipediaurl = json['wikipediaurl'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'about': about,
        'imageurl': imageurl,
        'noofreviews': noofreviews,
        'review': review,
        'summary': summary,
        'wikipediaurl': wikipediaurl,
      };
}
