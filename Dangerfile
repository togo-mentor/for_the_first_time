warn("PRがWIPになってるよ！🐶") if github.pr_title.include? "[WIP]"

warn("PRのタイトルが短すぎるよ！🐶") if github.pr_title.length < 5

warn("PRにタイトルが書かれてないよ！🐶") if github.pr_title.length == 0

warn("PRの説明が短すぎるよ！レビュアーが見て分かる説明を書いてね！🐶") if github.pr_body.length < 5

warn("PRにassigneeが設定されてないよ！🐶") unless github.pr_json["assignee"]

pr_has_screenshot = github.pr_body =~ /https?:\/\/\S*\.(png|jpg|jpeg|gif){1}/
warn("UIレビューの時はスクリーンショットを添付してね！🐶") if !pr_has_screenshot && github.pr_body.include?("スクリーンショット")

flutter_lint.only_modified_files = true
flutter_lint.report_path = "./flutter_analyze_report.txt"
flutter_lint.lint(inline_mode: true)
