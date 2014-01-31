module ActionStatus
  def status(code)
    it("renders #{code}") { expect(response.status).to eq code }
    self
  end

  def status_with_params!(code, mode="with parameters", &block)
    raise ArgumentError unless block
    it "renders #{code} #{mode}".strip do
      get(self.class.description, instance_eval(&block))
      expect(response.status).to eq code
    end
    self
  end

  def status_without_params!(code)
    status_with_params!(code, "without parameters") { }
    self
  end
end