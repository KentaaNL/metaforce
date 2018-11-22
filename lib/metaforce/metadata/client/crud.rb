module Metaforce
  module Metadata
    class Client
      module CRUD

        # Public: Create metadata
        #
        # Examples
        #
        #   client._create(:apex_page, :full_name => 'TestPage', label: 'Test page', :content => '<apex:page>foobar</apex:page>')
        def _create(type, metadata={})
          type = type.to_s.camelize
          message = { :metadata => prepare(metadata) }.merge(attributes!(type))
          request :create, :message => message
        end

        # Public: Delete metadata
        #
        # Examples
        #
        #   client._delete(:apex_component, 'Component')
        def _delete(type, *args)
          type = type.to_s.camelize
          metadata = args.map { |full_name| {:full_name => full_name} }
          message = { :metadata => metadata }.merge(attributes!(type))
          request :delete, :message => message
        end

        # Public: Update metadata
        #
        # Examples
        #
        #   client._update(:apex_page, 'OldPage', :full_name => 'TestPage', :label => 'Test page', :content => '<apex:page>hello world</apex:page>')
        def _update(type, current_name, metadata={})
          type = type.to_s.camelize
          message = { :metadata => {
            :current_name => current_name,
            :metadata => prepare(metadata),
            :attributes! => { :metadata => { 'xsi:type' => "tns:#{type}" } } }
          }
          request :update, :message => message
        end

        # Adds one or more new metadata components to your organization
        # synchronously.
        #
        # Available in API version 30.0 and later.
        #
        # Example: metadataResponse = client.create_metadata(:custom_object, :full_name => 'Test__c', :label => 'Test Object', :plural_label => 'Test Objects', :name_field => [:type => 'Text', :label => 'Test Name'], :deployment_status => 'Deployed', :sharing_model => 'ReadWrite')
        def create_metadata(type, metadata={})
          type = type.to_s.camelize
          message = { :metadata => prepare(metadata) }.merge(attributes!(type))
          request :create_metadata, :message => message
        end

        # Returns one or more metadata components from your organization
        # synchronously.
        #
        # Available in API version 30.0 and later.
        #
        # Example: metadataResponse = client.read_metadata(:custom_object, ["Test__c"])
        def read_metadata(type, fullNames)
          type = type.to_s.camelize
          message = { :type => type, :full_names => fullNames }
          request :read_metadata, :message => message
        end

        # Updates one or more metadata components in your organization
        # synchronously.
        #
        # Available in API version 30.0 and later.
        #
        # Example: metadataResponse = client.update_metadata(:profile, :fieldPermissions => [:field => 'Contact.'+get_namespace+'Test__c', :editable => true, :readable => true], :fullName => 'Admin')
        def update_metadata(type, metadata={})
          type = type.to_s.camelize
          message = { :metadata => prepare(metadata) }.merge(attributes!(type))
          request :update_metadata, :message => message
        end

        # Deletes one or more metadata components from your organization
        # synchronously.
        #
        # Available in API version 30.0 and later.
        #
        # Example: metadataResponse = client.delete_metadata(:custom_object, ["Test__c"])
        def delete_metadata(type, fullNames)
          type = type.to_s.camelize
          message = { :type => type, :full_names => fullNames }
          request :delete_metadata, :message => message
        end

        # Renames a metadata component in your organization synchronously.
        #
        # Available in API version 30.0 and later.
        #
        # Example: metadataResponse = client.rename_metadata(:custom_object, 'Test__c', 'TestTest__c')
        def rename_metadata(type, oldFullName, newFullName)
          type = type.to_s.camelize
          message = { :type => type, :old_full_name => oldFullName, :new_full_name => newFullName }
          request :rename_metadata, :message => message
        end

        def create(*args)
          Job::CRUD.new(self, :_create, args)
        end

        def update(*args)
          Job::CRUD.new(self, :_update, args)
        end

        def delete(*args)
          Job::CRUD.new(self, :_delete, args)
        end

      private

        def attributes!(type)
          {:attributes! => { 'tns:metadata' => { 'xsi:type' => "tns:#{type}" } }}
        end

        # Internal: Prepare metadata by base64 encoding any content keys.
        def prepare(metadata)
          metadata = Array[metadata].compact.flatten
          metadata.each { |m| encode_content(m) }
          metadata
        end

        # Internal: Base64 encodes any :content keys.
        def encode_content(metadata)
          metadata[:content] = Base64.encode64(metadata[:content]) if metadata.has_key?(:content)
        end

      end
    end
  end
end
