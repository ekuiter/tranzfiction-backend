module Actions
  def get!(action=nil, &block)
    if block
      before { get (action ? action : self.class.description), instance_eval(&block) }
    else
      before { get (action ? action : self.class.description) }
    end
    self
  end

  def status(code)
    it("renders #{code}") { expect(response.status).to eq code }
    self
  end

  def status_with_params!(code, mode="with parameters", &block)
    raise ArgumentError unless block
    it "renders #{code} #{mode}".strip do
      get self.class.description, instance_eval(&block)
      expect(response.status).to eq code
    end
    self
  end

  def status_without_params!(code)
    status_with_params!(code, "without parameters") { }
    self
  end

  def assigns(options, &block)
    if options.kind_of? Array
      options.uniq.each do |variable|
        assigns(variable, &block)
      end
    else
      variable = options.to_sym
      it("assigns @#{variable}") { expect(assigns(variable)).to eq (block ? instance_eval(&block) : send(variable)) }
    end
    self
  end

  def renders(hash=nil, &block)
    if hash.kind_of? Hash
      if hash[:template]
        it "renders template #{hash[:template].to_sym}" do
          expect(response).to render_template (block ? instance_eval(&block) : hash[:template].to_sym)
        end
      elsif hash[:json]
        it "renders @#{hash[:json].to_sym} as JSON" do
          expect(response.body).to be_json(block ? instance_eval(&block) : send(hash[:json].to_sym))
        end
      end
    elsif hash == :json
      it "renders json" do
        expect(response.body).to be_json(block ? instance_eval(&block) : nil)
      end
    elsif block
      it("renders") { expect(response.body).to eq instance_eval(&block) }
    else
      it("renders #{hash}") { expect(response.body).to eq hash }
    end
    self
  end

  def destroys(&block)
    raise ArgumentError unless block
    it "destroys" do
      hash = instance_eval &block
      collection = hash.delete :collection
      expect { get :destroy, hash }.to change { collection.count }.by(-1)
    end
    self
  end
end