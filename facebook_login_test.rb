require 'mechanize'

def login

  $agent = Mechanize.new
  $agent.user_agent_alias = "Android"
  login_page = $agent.get('https://m.facebook.com')
  login_form = $agent.page.form_with(:method => 'POST')

  login_form.email = 'id'
  login_form.pass = 'pass'

  $agent.submit(login_form)

end

def fetchFriendList(startIndex)

  puts "fetching https://m.facebook.com/profile.php?v=friends&startindex=#{startIndex}"
  puts ""

  friend_list = $agent.get('https://m.facebook.com/profile.php?v=friends&startindex=#{startIndex}').body
  doc = Nokogiri::HTML.parse(friend_list)

  xpath = '//*[@id="root"]/div[1]/div[2]/div[2]/div'

  count = 0
  doc.xpath(xpath).each do |friend|

    count = count + 1

    # name, ID, profile URL, imageURL
    img_xpath = 'table/tbody/tr/td[1]/img'
    name_xpath = 'table/tbody/tr/td[2]/a'

    href = friend.xpath(name_xpath).attribute('href')
    name = friend.xpath(img_xpath).attribute('alt')
    imageURL = friend.xpath(img_xpath).attribute('src')

    puts 'Name: ' + name
    puts 'ID: ' + href.to_str.match(/\/(.*?)\?/)[1]
    puts 'profile URL: ' + 'https://www.facebook.com' + href
    puts 'imageURL: ' + imageURL

    puts ""
  end

  count

end


def main

  login
  count = fetchFriendList(0)
  puts count

end

# entryPoint
main
