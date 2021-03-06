require 'hammer_cli'
require 'katello_api'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class SubscriptionCommand < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIForeman::ListCommand
      resource KatelloApi::Resources::Subscription, 'index'

      output do
        field :id, "ID"
      end

      apipie_options
    end

    class UploadCommand < HammerCLIForeman::WriteCommand
      resource KatelloApi::Resources::Subscription, 'upload'
      command_name "upload"

      class BinaryFile < HammerCLI::Options::Normalizers::File
        def format(path)
          ::File.new(::File.expand_path(path), 'rb')
        end
      end

      def request_headers
        {:content_type => 'multipart/form-data', :multipart => true}
      end

      success_message "Manifest is being uploaded"
      failure_message "Manifest upload failed"

      apipie_options
      option "--file", "MANIFEST", "Subscription manifest file",
             :attribute_name => :option_content,
             :required => true, :format => BinaryFile.new
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand("subscription", "Manipulate subscriptions.",
                                  HammerCLIKatello::SubscriptionCommand)
