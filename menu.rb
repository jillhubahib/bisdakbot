class Menu
  def self.enable
    Facebook::Messenger::Thread.set({
      setting_type: 'call_to_actions',
      thread_state: 'existing_thread',
      call_to_actions: [
        {
          type: 'postback',
          title: 'Hugot Line',
          payload: 'HUGOTLINE'
        },
        {
          type: 'postback',
          title: 'Asa ko',
          payload: 'ASAKO'
        }
      ]
    }, access_token: ENV['ACCESS_TOKEN'])
  end
end
