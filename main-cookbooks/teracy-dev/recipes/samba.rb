if node['teracy-dev']['samba']['enabled']
    node.override['samba']['passdb_backend'] = 'tdbsam'
    node.override['samba']['config'] = '/etc/samba/smb.conf'
    include_recipe 'samba::server'
end
