App = {
    web3Provider: null,
    contracts: {},

    init: async function() {
        return await App.initWeb3();
    },

    initWeb3: async function() {
        /*
         * Replace me...
         */
        // Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access");
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider(
                'http://localhost:8545');
        }
        web3 = new Web3(App.web3Provider);

        return App.initContract();
    },

    initContract: function() {
        $.getJSON('Entry.json', function(data) {
            // Get the necessary contract artifact file and instantiate
            // it with truffle-contract
            var AdoptionArtifact = data;
            App.contracts.Entry = TruffleContract(EntryArtifact);

            // Set the provider for our contract
            App.contracts.Entry.setProvider(App.web3Provider);

            // Use our contract to retrieve and mark the adopted pets
            return App.markAdopted();
        });

        return App.bindEvents();
    },

    // bindEvents: function() {
    //     $(document).on('click', '.btn-adopt', App.handleAdopt);
    // },

    markAdopted: function(adopters, account) {
        // TODO


        // var adoptionInstance;

        // App.contracts.Adoption.deployed().then(function(instance) {
        //     adoptionInstance = instance;

        //     return adoptionInstance.getAdopters.call();
        // }).then(function(adopters) {
        //     for (i = 0; i < adopters.length; i++) {
        //         if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
        //             $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
        //         }
        //     }
        // }).catch(function(err) {
        //     console.log(err.message);
        // });
    },

    handleAdopt: function(event) {
        event.preventDefault();

        var whId = parseInt($(event.target).data('id'));

        var entryInstance;

        web3.eth.getAccounts(function(error, accounts) {
            if (error) {
                console.log(error);
            }

            var account = accounts[0];

            App.contracts.Entry.deployed().then(function(instance) {
                entryInstance = instance;

                // Execute adopt as a transaction by sending account
                return adoptionInstance.adopt(whId, {from: account});
            }).then(function(result) {
                return App.markAdopted();
            }).catch(function(err) {
                console.log(err.message);
            });
        });

    }
};

$(function() {
    $(window).load(function() {
        App.init();
    });
});
