module ApplicationHelper
  def full_title(page_title = "") # イコールだよ
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty? # if page_title.empty?で文字列が空かどうか
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end

# def yeller(array)
#   array.map(&:upcase).join("")
# end

# def string_shuffle(s)
#   s.split("").shuffle.join("") # shuffleはarrayになっちゃうんだね
# end

# hash = { "one" => "uno", "two" => "dos", "three" => "tres" }

# class Word
#   def palindrome?(string)
#     string == string.reverse
#   end
# end

# class Word < String #* stringうけとるからstirng classを継承したほうが自然
#     def palindrome?(string)
#     string == string.reverse
#   end
# end


# class String
#   def shuffle
#     self.split("").shuffle.join("")
#   end
# end
