class Main

  def self.execute
    bot = Discordrb::Bot.new(client_id: ENV['BOT_CLIENT_ID'], token: ENV['BOT_TOKEN'])

    # bot.message(containing: "てす") do |event|
    #   # p event
    #   # p event.class
    #   event.respond "テスト1 #{event.user.name}"
    #   event.respond "https://illustimage.com/photo/dl/2951.png?20220102"
    #   dynamodb_client = Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
    #   # dynamodb_client = Aws::DynamoDB::Resource.new(region: 'ap-northeast-1')
    #   # table = dynamodb.table('discord_bot_users')

    #   table_item = {
    #     table_name: 'discord_bot_users',
    #     return_consumed_capacity: "TOTAL",
    #     item: {
    #       id: 'aaa',
    #       logined_dates: { '202206': ['01', '02', '03'] },
    #     }
    #   }

    #   add_item_to_table(dynamodb_client, table_item)
    # end

    # def add_item_to_table(dynamodb_client, table_item)
    #   dynamodb_client.put_item(table_item)
    #   puts "Add"
    # # rescue StandardError => e
    # #   puts "Error adding movie '#{table_item[:item][:title]} " \
    # #     "(#{table_item[:item][:year]})': #{e.message}"
    # end

    bot.voice_state_update do |event|
      event.user.id
      user = User.find_or_initialize_by(discord_id: event.user.id)

      # 新規ユーザーの場合はsave
      if user.new_record?
        user.name = event.user.name
        user.save
      end

      login_date = LoginDate.find_or_initialize_by(user_id: user.id, login_date: Date.today)

      if login_date.new_record?
        login_date.save
        bot.send_message(ENV['LOGIN_BONUS_CHANNEL_ID'], logind_message(user))
      end

    end

    bot.run
  end
end

def logind_message(user)
  "🎉#{user.name}さん 今日もお疲れ様です！ 今月のログインは#{LoginDate.count_this_month(user.id)}日目です🎉"
end