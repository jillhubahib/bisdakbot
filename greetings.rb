class Greetings
  def self.enable
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'new_thread',
      call_to_actions: [
        {
          payload: 'START'
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])

    Facebook::Messenger::Thread.set({
      setting_type: 'greeting',
      greeting: {
        text: 'Musta bai!'
      },
    }, access_token: ENV['ACCESS_TOKEN'])
  end
end
