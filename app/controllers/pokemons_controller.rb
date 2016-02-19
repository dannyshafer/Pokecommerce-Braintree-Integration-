class PokemonsController < ApplicationController
  require "rubygems"
  require "braintree"

  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = ENV['MERCHANT_ID']
  Braintree::Configuration.public_key = ENV['PUBLIC_KEY']
  Braintree::Configuration.private_key = ENV['PRIVATE_KEY']

  # GET /pokemons
  # GET /pokemons.json
  def index
    @pokemons = Pokemon.all
  end

  # GET /pokemons/1
  # GET /pokemons/1.json
  def show
    @pokemon = Pokemon.find(params[:id])
    @token = Braintree::ClientToken.generate
  end

  # GET /pokemons/new
  def new
    @pokemon = Pokemon.new
  end

  # GET /pokemons/1/edit
  def edit
  end

  # POST /pokemons
  # POST /pokemons.json
  def create
    @pokemon = Pokemon.new(pokemon_params)

    respond_to do |format|
      if @pokemon.save
        format.html { redirect_to @pokemon, notice: 'Pokemon was successfully created.' }
        format.json { render :show, status: :created, location: @pokemon }
      else
        format.html { render :new }
        format.json { render json: @pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pokemons/1
  # PATCH/PUT /pokemons/1.json
  def update
    respond_to do |format|
      if @pokemon.update(pokemon_params)
        format.html { redirect_to @pokemon, notice: 'Pokemon was successfully updated.' }
        format.json { render :show, status: :ok, location: @pokemon }
      else
        format.html { render :edit }
        format.json { render json: @pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pokemons/1
  # DELETE /pokemons/1.json
  def destroy
    @pokemon.destroy
    respond_to do |format|
      format.html { redirect_to pokemons_url, notice: 'Pokemon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkout
    nonce = params[:payment_method_nonce]
    result = Braintree::Transaction.sale(
    :amount => "10.00", #could be any other arbitrary amount captured in params[:amount] if they weren't all $10.
    :payment_method_nonce => nonce,
    :options => {
      :submit_for_settlement => true
      }
    )
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pokemon_params
      params.require(:pokemon).permit(:name, :image_url)
    end
end
