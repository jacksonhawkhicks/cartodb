require_dependency 'carto_gears_api/users/user'
require_dependency 'carto_gears_api/organizations/organization'

module CartoGearsApi
  module Users
    class UsersService
      # Returns the logged user at the request.
      #
      # @param request [ActionDispatch::Request] CARTO request, as received in any controller.
      # @return [User] the user.
      def logged_user(request)
        user(request.env['warden'].user(CartoDB.extract_subdomain(request)))
      end

      private

      def user(user)
        CartoGearsApi::Users::User.with(
          id: user.id,
          username: user.username,
          email: user.email,
          organization: user.organization ? organization(user.organization) : nil,
          feature_flags: user.feature_flags,
          can_change_email: user.can_change_email?
        )
      end

      def organization(organization)
        CartoGearsApi::Organizations::Organization.with(name: organization.name)
      end
    end
  end
end
