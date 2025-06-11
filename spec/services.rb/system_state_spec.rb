
RSpec.describe SystemState do
  
  describe "restock" do
    let!(:card1) { Card.create(suit:"spade", card: "5") }
    let!(:card2) { Card.create(suit:"heart", card: "6") }
    let!(:card3) { Card.create(suit:"spade", card: "8") }

    it "should lose 50 cents per lost card" do
      card2.stocking.update(rental_status: Stocking::LOST)
      card3.stocking.update(rental_status: Stocking::LOST)

      SystemState.instance.restock

      expect(SystemState.instance.balance).to eq(4.0)
    end
  end
end