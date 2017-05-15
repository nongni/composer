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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�p�@p����}���Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!�V�/o����;����GI���_.����^q��:.�?�V������>[ǩ��@�\�$MS����5|��/��t9��{Lĝ��^u�=��G�w>�=�p'�4��?+�Z�?3�i�v1w��<��)��Q��Q�b��q�e����Q��HsmǣHE��o��{~�2������I���ǋ�_jH�����#8�!�5�����eb�-Z�<Hi�<�DQ��x�M��`���`5Jq-�j(�����LH-;��Oc7x~��+�\l�M�B ��������y>���>EѨ�(Ds�Ձ���x����d+!u#�dh�J3�'�m�//d])n���-Q�r�u��7��XQ^z����S�����h�t�t�s��r��*~*��|���2��o�?zp�W�?J��S�O ��/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� Jq#�D�S�&e�p�u#2�q�p�)��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x=X�b�#���4y���rK;
��[0Qx�Tv��й������i,"om졸�f`p�s�,�\Í���-�ܷ
�@��Y����_1��㡹7��R1���)n�M�'
�No

�8�WňP�<�9���n$�)a7�a/�-��bc���9}���)�h'�rVr�P����]i�Y&n��Vw�t3עf��)�8>�'�"�xy2�S4�E������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��F��=3��/��l������(^�)� �?Jj����S���"������������u�����Nݯv�zK qO��|h��x,fȑ8N�
��Q/!T�G��vB>$��N=��"��U�TA������^���i�$��h�o``a���x6ad1Ok�K��w��Dѭ\������5$B}ٚ8������ˇ��B�7�<6]�+�<s�y�i��}߁��{o��]~�-C��e[�*�ቪ{@k�(̶p-�#��4M93rր�6�����C�� �v~�d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D��K}0�m�`B2���q���D���ϛX��X��P���o�m������}?��Z2��h�Y�!���:��x��_�������
T�_>D�?s�����G(����T���W���k���sL���O�8R��%�f�Oe���*�������O��$�^@�lqu�"���a��a���]sY��(?pQ2@1g=ҫ��.�!�W����PU�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ��y/~i�f�O�_
>J���W��T���_��W���K�f�O�������(�#�*���-�gz����C��!|��l����:�f��w�бY��{�Ǧ��|h ���N����p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��3���������3�*�/��_�������o�����#�.�� �����%���_��������T�_���.���(��@�"�����%��16���ӏ:��O8C������빁[�8�(���H��>��,IRv�����_���ERe�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U��������~����(MT���������S�߱�CU������2�p��q���)x��$޾|Y9\.��J�e�#���vЋ口R��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v�w�U���w��P�xj�Q����������� ��h�
e���b���4��@���J�k�_�c���?��s Vrt��_c	K ��o����>��gI ���1v?n���AUZ.�wAU��72���A�o>�a=:�;���@C��~شs�ā�ɧ>;�S�żx��ж�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�Gz�I��9|��I,̹����p�wk�ʹ�Q�hMX���UjS����ҝJ���9�[a��5� �RgD��ކ��t�w��n7�5���`��Ԝ��]]q��B[��n;i�圳�xJX9[��1�C�y��L;AO�%�����ӻ�����E�/��4����>R���������oa�Sxe��M��������-Q��_�����$P�:���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��P~�(�|�n#�[�������<�Z�� 컦�Oܖ����yЃ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^;zz ��σ8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .������J�oa����?��?%�3�����A������?+���Q��W�������F���S`.��1����\.�˭�������,�W�_��������E=_�����\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:������Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������Qg��>Z|�=~>��b�?=��@����J��O�B�����A��n���}�j5�F��Zm١��6�'~�𽰘����S�ʵ���"��k�����>}�_n�i�����\I�vU� ���n�]E��k�a�W�v���I����u��FH���ϿNi�������MjWn���uԎ�]׮����jE0]��W���<�������z>��ڕS;m��z���ծ�Sl��&���5|ɩn_�����\�ӥ��,���}sWT��nG���w����b���.����4DU�A�#�Q�����7����b��/��hv�oGپVT�;?��Z��u�i�]�>ʵ�(��ˍ���{��{�@���҂�?oA�%wۋ��M�7\G,��^d/?��-�D��n�Žyx��}�!?��S������Okӻ]��o��yU������{,���-��JcK����<N��ex�Mӯ58N�p'�zg����d�\*��������'��Ё�Q"?Rg5�|j��G�>���o�pD�=u���)��p,s�b໺x�7���]A�G"?0DCV�����-��eUqd|[��q��sF�ue���YNw_a�����)�n��ْ��N��'{b1n������6�u����r9<.��r�˘�b���u�K��tݺ�t�ֽoJ�=]�n�֞v��5!&��4�o4B�@�D?)����A	$D�`����ж�z��휝����&�t��y���������y��ۛ���Lg̃�M�Wn�͠��LCĮ�~�H&�X$�g����h� k$���R���H<��ֶ�P=I]���}N'��u�fZL�2:]Z�����ټ�yxfs��s@	��0.�Î��;��$�=�n��Dsp�n�\�wBs�-3���U�n z-��6`��j���G���n+����6j��U� ����3���s�J�~��d&;�!���d��u��ĸ�R������n猛p��>��kƙ����҈y$DfUJ��g�e�hY�}�F����[(-�KCƬ��+|��]�=t��,/j���r4E>�h�C޷h�Ц�9
�.�dé�G�S��b�p�~Gp:91�Ӏٝ�#Z����� vr��"�A�;�ʢ޾sa�����1�I�Vc�2Ǻj��/dtI:�4`q���9�:�!���p�w��9��S�l�k��f$tQ������7��]������
C0��e�����C�|��.8.���_�a*�Jc�1CJ��&o=�^��]�E.��-j�"Ƀ[kgk��.לP�Օ��М���H���=����L��*�T����
��w�y>��܃sэ\�f����ǜ�n��!3�%8��t�v1A3�6'f�aoZ�w:��Υ�S����0W����ꪽ$���u�v!Gk��]{�#Xvu����W��j:��>��Ѽqѹ�B�{��'�daý���U���ܨ�������������'�J<
k'6N�=���~~��ZK%.<��T�~��U z
������ߏ��m/ˣ����U�.}T�|����á����Cp��ޡ���_���/��z��j�'�M��~�ң��
���n�OP�Ϝ��q ��z�N v��Ћwn����8|���s��f����� glj�oj��/n
sF�>����,n���^T�t����X��6z	c�yN�=W���D��� C�w~�����2]�a���f��#��!xv�e��l�(�ϐn7�/D�����
m�Y@�����50_����N��4�/�(������}N6s��x� �8���dC�`)Ly����~��0�DW�h5����tp�#\�ǔ� �O�ɂ}v{k�P&���Lc3U\dB*�=�z6ߣ�x���
�SՖ���KAI�VIUe�e�!>��RjJ��^o���,��#�AO����6�f®��>a�C�R�"lxjSOa�M=�!�5;��f{��Ss%dݪ�8���Z4]S�7������@&)m���v���e����_�D� �˓����=������b&Lf�p>!� a��!+�;LI�S0ӂ� jG2,���	xY��Ȏ��!+މl�� ���x�UR�e�����b9!�)_��b5͋��8P2���*�F���\5�L��v"^ ��0����1&��6�ﾲ��IY�l�:�,[��f�; �\��v8���p�w'�f�C�W{Z�3\+�;�p�EZ�J(Ɗ��ؤ��8%��J��reeP�m�pʂ3�׊�ÅTP4M��<�iI�9e�#<#�TY����}4�����ct��ʁ��a����YO8ޤE1�e0�sޝ����[HP�����5�r�W�&ݾXB�sU����VYb����@Y��+K}e����P�U��(I��,�8@��Н:C���.`^د�y���Pø-�[;�vbX)W�x��A�a$&5����)KXL֤� �{Q5P�A�aR�t��1Ȝ����]�,Lh�}��b�Z�J� ӽA�����BΛM����`�͆����d_k�\���>O����lRd�d�p{��N��OY���f�l�϶�϶q
7~���Z�W5�#й�+�h:��=�v����Wi+�����C��}*�:tf:����U�y�r��6���6'!v�ӆn��W����f���*o~J�R�@7A7�p��6.I��w���QL!�km�f~�Р����'�3|K�hف�C��)pR�%�q�k��djC�:��~�9���;��tZ�s:�v&��OX2�A��g�Z�l9tt�.|��8�ʳ�͒����<�e�@ϝ�qE��bT�3硗!#�bF���Dhq���4�	� \mF���O������y��Q���u�u�o���/�K��/�8t�LZ�-�P�J+�@��ny��s
Ǿ𠥎�H[�h,:Ύs��hP���V]p��g��������U��4��5e��;��D�O���"�ΐڔ�"�U=lD�"��L )ni��H��H4�D@?T�H�+$�B���bJy4�;��:�Ը��^+4�1U94��JO��b�zχ�HPH���iL���qs��Q�!b�X�&i�"���3��Vu�[�!F3��4b#}i>���'���_z[
*�8� -�Ź��������@�� ߧz1!��-�B�<��Z�Y�4`�:���Y����RM+��1��8��q��a�~�k�K��Mw*o�r.O���1��1�V́X��=���S��N[v}މ��>��r��u��]����{X���aّ�N$m�A$3a�p%����%�h�lN�T>����`1�ʃ��\�y�zP�	�Lb"�A�I��((2ݬ)��O�����;��`�6�&����"�� I�pDl�4Nm��Q:(L��h�Ea���.	7B��tpY�ÃA��ӥ��P1!-LC��B�a�!������� ��r����&ߎzv8��R�'�D]�B�����G�/����b�|T�_�J�
���`�<���,�@�~6�}�+[r����kbbK����,�k�z)�v�I�U��Haߥ�W��l㰍���8���g#~+9e�C;e39V}��[!̶q�j��Bl����Xk	�����Ռ��GO7L���#�x����kz�� ����Z�����P\d��&Ak�T&�������+w��Q�&���$t��rs/����#�}s����F藿��S����/������8t��kv���{�w��lZ8Q���8���z���a,f�?/C�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}��2p�  