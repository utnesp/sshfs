sshfs <- function(remote_path, local_path, servername=NULL, id_rsa_path = NULL, useStallo = T) {
    if(is.null(servername)) servername = "YourUserName@YourServer.com:" # put your most used user and servername here to avoid typing in this everytime instantiating this process
    remote_path=paste(servername, remote_path, sep = "")
    suppressWarnings(if(file.exists(local_path)) system(paste("umount -f", local_path))) # if a mount point exist, unmount it first
    system(paste( "mkdir -p", local_path))
    if(is.null(id_rsa_path)) id_rsa_path="~/.ssh/id_rsa" # put the path to your id_rsa file her
    system(paste("sshfs -o Ciphers=arcfour,Compression=no,auto_cache,reconnect,allow_other,defer_permissions,IdentityFile=", id_rsa_path, " ", remote_path, " ", local_path, sep = ""))
}
