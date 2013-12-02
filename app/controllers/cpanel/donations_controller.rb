# coding: utf-8
class Cpanel::DonationsController < Cpanel::ApplicationController

  def index
    @donations = Donation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @donations }
    end
  end

  def show
    @donation = Donation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @donation }
    end
  end

  def new
    @donation = Donation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @donation }
    end
  end

  def edit
    @donation = Donation.find(params[:id])
  end

  def create
    @donation = Donation.new(params[:donation])
    
    respond_to do |format|
      begin
        p = Project.find(params[:donation][:project_id])
        p.update_attributes!(raised_amount: p.raised_amount + params[:donation][:amount].to_i)
        @donation.save
        format.html { redirect_to cpanel_donations_url, notice: '添加捐赠记录成功.' }
        format.json { render json: @donation, status: :created, location: @donation }
      rescue => e
        format.html { render action: "new", errors: e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  def update
    @donation = Donation.find(params[:id])

    respond_to do |format|
      begin
        p = @donation.project
        p.update_attributes!(raised_amount: p.raised_amount - (@donation.amount || 0) + params[:donation][:amount].to_i)
        @donation.update_attributes!(params[:donation])
        format.html { redirect_to cpanel_donations_url, notice: '修改捐赠记录成功.' }
        format.json { head :no_content }
      rescue => e
        format.html { render action: "edit", errors: e.message }
        format.json { render json: e, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to cpanel_donations_url }
      format.json { head :no_content }
    end
  end
end
