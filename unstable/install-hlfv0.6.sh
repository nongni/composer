(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �[o�0�yx������$
)E%��OQH\��MΥeS���ABºJզI�I�r����9��	�"M;�� B�����H�t��.^]���!I���;�ԆՉmQ�j �(e�(� ��X)�N�^�����D8�eP���E���F�|���%���fo `�Z!��!".rV�֒`��S>]w�N�	[���	J1z�F����� h���l����l�O1	|��A4V�7��k����=�S&�Utc��LF�ֳ|G�EK�i_�9D��)ZȢ���Md6�h�`���Mb6�7+�O5Ŝ)�f�M���ܘC���1M�`6M�n��'Y��"I|�ɶs+��� u:�&CSU��(7�a��G�.M^�c�yd*�3`7WqV�z�zU���ҟk#��Um��t]1�b���#}��;~�=]���K#ӻ�����m�.�֠i�F�"�ˏ�u�v��/�n��lUœOTtwN����K�]k�"A�;�-}���.����t�؊�Oǳ�N�؟NnGC|�9 ���n���73<`Eu�������CK��-Q�As~�pPd�O0��!1�6R����b*��\vn�va�z�L#���,���	rhV��F�IvY\�P��sMeӭHh�|���	X/��c�@e-JiwɲR/U�-t����R,AXa?6� *H�so�煺��[���B~Mȣ���>�n��W�O�����p8���p8���p8���p8���O'3Q (  