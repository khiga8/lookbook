module ComponentSpecHelper
  def lookbook_example(lookup_path = "button/playground")
    Lookbook.previews.find_example_by_path(lookup_path)
  end
end
