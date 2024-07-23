class DashboardController < ApplicationController

    def show
        redirect_to articles_path if logged_in?
    end

end
