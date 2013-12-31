module AddressesHelper
	require 'bitcoin'
	@key = Bitcoin::generate_key

	@address = Bitcoin::pubkey_to_address(@key[1])

	# p 'generate_address: ' 
	# p Bitcoin::generate_address

	# p key
	# p address

	# x=Bitcoin::pubkey_to_address('04ac7493447d11e1923e3fe40f08c0660af227ead05697ea0f62c282fb4a9cbb28d41e2e995828ff3d4d8906d770ac19b9ca1857c91976c0045c1b2ac95225ee0f')
	# p Bitcoin::valid_address? '04ac7493447d11e1923e3fe40f08c0660af227ead05697ea0f62c282fb4a9cbb28d41e2e995828ff3d4d8906d770ac19b9ca1857c91976c0045c1b2ac95225ee0f'

	# def generate_address
	#   prvkey, pubkey = generate_key
	#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
	# end


	# (1..10).each do |c|
	# result = []
	# result << c
	# result << Bitcoin::generate_address[0,3]	
	# p result
	# end
end
