require 'active_support/core_ext/string/strip'
require_relative 'attachment'

module Griddler
  module Postmark
    class Adapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        {
          to: extract_recipients(:ToFull),
          cc: extract_recipients(:CcFull),
          bcc: extract_recipients(:BccFull),
          original_recipient: params[:OriginalRecipient],
          reply_to: params[:ReplyTo],
          from: full_email(params[:FromFull]),
          subject: params[:Subject],
          message_id: params[:MessageID],
          text: params[:TextBody],
          html: params[:HtmlBody],
          attachments: attachment_files,
          headers: headers
        }
      end

      private

      attr_reader :params

      def headers
        Array(@params[:Headers]).inject({}) do |hash, header|
          hash[header[:Name]] = header[:Value]
          hash
        end
      end

      def extract_recipients(key)
        params[key].to_a.map { |recipient| full_email(recipient) }
      end

      def full_email(contact_info)
        email = contact_info[:Email]
        if contact_info[:Name].present?
          "#{contact_info[:Name]} <#{email}>"
        else
          email
        end
      end

      def attachment_files
        attachments = Array(params[:Attachments])

        attachments.map do |attachment|
          Griddler::Postmark::Attachment.new({
            filename: attachment[:Name],
            type: attachment[:ContentType],
            tempfile: create_tempfile(attachment),
            content_id: attachment[:ContentID]
          })
        end
      end

      def create_tempfile(attachment)
        filename = attachment[:Name].gsub(/\/|\\/, '_')
        tempfile = Tempfile.new(filename, Dir::tmpdir, encoding: 'ascii-8bit')
        tempfile.write(content(attachment))
        tempfile.rewind
        tempfile
      end

      def content(attachment)
        if content = attachment[:Content]
          Base64.decode64(content)
        else
          content
        end
      end
    end
  end
end
