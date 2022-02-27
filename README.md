# Simple Ethereum-based prediction market

This prediction market does not yet allow for external creation of new markets (contracts must be deployed each time) and also has not implemented decentralised resolution (in reality, this would likely be outsourced to Kleros et al in the event of disputed market outcome). The current resolution process is through a threshold N of M vote (where N is decided beforehand, and the recipient list of M can be added to).

Follows the model of other prediction markets, three outcome tokens for each market with the winning outcome having a redemtpion value of 1 USD and the others resolve to 0 USD. 


```
