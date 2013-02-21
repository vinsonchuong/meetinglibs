module FeatureHelpers
  def sign_in(options)
    if options[:via] == :calnet
      cas_user =  ENV['CAS_USER']
      calnet_id =  ENV['CALNET_ID']
      calnet_passphrase =  ENV['CALNET_PASSPHRASE']
      unless [cas_user, calnet_id, calnet_passphrase].all?(&:present?)
        pending 'CalNet credentials not specified'
      end

      User.create!({cas_user: cas_user}.merge(options[:with] || {}))
      visit '/'
      click_link 'CalNet Authentication'
      fill_in 'CalNet ID', with: calnet_id
      fill_in 'Passphrase', with: calnet_passphrase
      click_button 'Sign In'
    else
      if options[:with].class == User
        token = options[:with].token
      else
        User.create!({token: 'token'}.merge(options[:with] || {}))
        token = options[:via] == :invalid_token ? 'invalid' : 'token'
      end

      visit '/'
      fill_in 'invitation token', with: token
      click_button 'Sign In'
    end
  end
end
