#!/bin/bash

# Ejecutar ./test.sh -b -v

# Colores
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m"

# Banner
echo -e "${GREEN}

                ==
              @@@@@@
            @@@@  @@@@
          @@@@  ..  @@@@
          @@  @@@@@@  @@
          @@ @@@@@@@@ @@
          @@ @@    @@ @@
           @  @    @  @
           @@  @  @  @@
            @   @@    @
            @        @
       @@@:  @ :  : @  :@@@
  @@@@   @@@  @    @  @@@   @@@@
 @@    @@@   @      @   @@@    @@
 @    @@%   @        @   %@@    @
      @@    @-      -@    @@
       @@    @      @    @@
             :@    @:
               @  @
               @  @         LIBFT Crash-Kraken by fran-byte
${NC}"

echo -e " Ejecutar ./test.sh -b -v "
# Colores
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
NC="\033[0m"

# Variables
TEST_DIR="libft_test"
LOG_FILE="libft_test.log"
PASSED=0
FAILED=0
COMPILE_BONUS=0  
NAME="libft.a"


# Control para compilar bonus
# Procesar opciones de línea de comandos
while getopts "vb" opt; do
    case $opt in
        v) VERBOSE=1 ;;  # Flag para output detallado
        b) COMPILE_BONUS=1;;
        *) echo "Uso: $0 [-b][-v]" >&2
           exit 1 ;;
    esac
done

> $LOG_FILE   # limpiar log antes

echo -e "${CYAN}Compilando libft normal...${NC}"
if ! make >> $LOG_FILE 2>&1; then
    echo -e "${RED}Error compilando libft. Revisa el log:${NC}"
    cat $LOG_FILE
    exit 1
fi

# Verifica que libft.a existe
if [ ! -f "libft.a" ]; then
    echo -e "${RED}Error: No se generó libft.a. Revisa errores de compilación.${NC}"
    cat $LOG_FILE
    exit 1
fi

# Limpiar ejecuciones anteriores
rm -rf $TEST_DIR
mkdir -p $TEST_DIR
> $LOG_FILE

# ========================================
# FUNCIONES AUXILIARES
# ========================================

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}[OK]${NC} $2"
        ((PASSED++))
    else
        echo -e "${RED}[KO]${NC} $2"
        ((FAILED++))
        echo -e "Detalles: $3" >> $LOG_FILE
    fi
}

compile_test() {
    local test_code=$1
    local test_name=$2
    echo -e "$test_code" > $TEST_DIR/$test_name.c
    gcc -Wall -Wextra -Werror -I. $TEST_DIR/$test_name.c -L. -lft -o $TEST_DIR/$test_name 2>> $LOG_FILE
    return $?
}

run_test() {
    local test_name=$1
    local test_code=$2
    local description=$3
    local expected=$4
    
    compile_test "$test_code" "$test_name"
    local compile_result=$?
    
    if [ $compile_result -eq 0 ]; then
        local output=$($TEST_DIR/$test_name)
        if [ "$output" == "$expected" ]; then
            print_result 0 "$description"
        else
            print_result 1 "$description" "Esperado: '$expected', Obtenido: '$output'"
        fi
    else
        print_result 1 "$description" "Error de compilación"
    fi
}

# ========================================
# TESTS CORREGIDOS
# ========================================

test_isalpha() {
    print_header "ft_isalpha"
    run_test "test_isalpha1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalpha('\''A'\'')); }' \
        "Letra mayúscula" "1"
    
    run_test "test_isalpha2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalpha('\''z'\'')); }' \
        "Letra minúscula" "1"
        
    run_test "test_isalpha3" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalpha('\''5'\'')); }' \
        "Dígito" "0"
}

test_isdigit() {
    print_header "ft_isdigit"
    run_test "test_isdigit1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isdigit('\''9'\'')); }' \
        "Dígito" "1"
        
    run_test "test_isdigit2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isdigit('\''a'\'')); }' \
        "Letra" "0"
}

test_isalnum() {
    print_header "ft_isalnum"
    run_test "test_isalnum1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalnum('\''A'\'')); }' \
        "Letra" "1"
        
    run_test "test_isalnum2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalnum('\''5'\'')); }' \
        "Dígito" "1"
        
    run_test "test_isalnum3" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isalnum('\''@'\'')); }' \
        "Carácter especial" "0"
}

test_isascii() {
    print_header "ft_isascii"
    run_test "test_isascii1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isascii(65)); }' \
        "ASCII válido (A)" "1"

    run_test "test_isascii2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isascii(200)); }' \
        "ASCII inválido (>127)" "0"
}

test_isprint() {
    print_header "ft_isprint"
    run_test "test_isprint1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isprint(32)); }' \
        "Carácter imprimible (espacio)" "1"

    run_test "test_isprint2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_isprint(127)); }' \
        "Carácter no imprimible (DEL)" "0"
}

test_bzero() {
    print_header "ft_bzero"
    run_test "test_bzero1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char str[] = "Hello"; ft_bzero(str, 3); for (int i = 0; i < 5; i++) printf("%d", str[i]); }' \
        "Primeros 3 bytes a cero (ASCII)" "000108111"
}

test_strlen() {
    print_header "ft_strlen"
    run_test "test_strlen1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%zu", ft_strlen("Hola")); }' \
        "Cadena normal" "4"
        
    run_test "test_strlen2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%zu", ft_strlen("")); }' \
        "Cadena vacía" "0"
}

test_memset() {
    print_header "ft_memset"
    run_test "test_memset1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char str[50] = "Hola mundo"; ft_memset(str, '\''*'\'', 5); printf("%s", str); }' \
        "Rellenar con asteriscos" "*****mundo"
}

test_memcpy() {
    print_header "ft_memcpy"
    run_test "test_memcpy1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char src[] = "origen"; char dest[10] = "destino"; ft_memcpy(dest, src, 6); printf("%s", dest); }' \
        "Copiar parcialmente" "origeno"
}

test_strlcpy() {
    print_header "ft_strlcpy"
    run_test "test_strlcpy1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char dest[10]; char src[] = "hola"; size_t len = ft_strlcpy(dest, src, sizeof(dest)); printf("%zu|%s", len, dest); }' \
        "Copiar cadena completa" "4|hola"
}

test_atoi() {
    print_header "ft_atoi"
    run_test "test_atoi1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_atoi("12345")); }' \
        "Número positivo" "12345"
        
    run_test "test_atoi2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_atoi("-54321")); }' \
        "Número negativo" "-54321"
        
    run_test "test_atoi3" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%d", ft_atoi("   42")); }' \
        "Con espacios" "42"
}

test_calloc() {
    print_header "ft_calloc"
    run_test "test_calloc1" \
        '#include "libft.h"\n#include <stdio.h>\n#include <string.h>\nint main() { int *arr = (int *)ft_calloc(5, sizeof(int)); int i, success = 1; for (i = 0; i < 5; i++) if (arr[i] != 0) success = 0; free(arr); printf("%d", success); }' \
        "Memoria inicializada a cero" "1"
}

test_strdup() {
    print_header "ft_strdup"
    run_test "test_strdup1" \
        '#include "libft.h"\n#include <stdio.h>\n#include <string.h>\nint main() { char *dup = ft_strdup("Hola"); printf("%s", dup); free(dup); }' \
        "Duplicar cadena" "Hola"
}

test_toupper() {
    print_header "ft_toupper"
    run_test "test_toupper1" \
        '#include "libft.h"\n#include <ctype.h>\n#include <stdio.h>\nint main() { printf("%d", ft_toupper('\''a'\'') == toupper('\''a'\'')); }' \
        "Convertir a mayúscula" "1"
        
    run_test "test_toupper2" \
        '#include "libft.h"\n#include <ctype.h>\n#include <stdio.h>\nint main() { printf("%d", ft_toupper('\''Z'\'') == toupper('\''Z'\'')); }' \
        "Carácter ya mayúscula" "1"
}

test_tolower() {
    print_header "ft_tolower"
    run_test "test_tolower1" \
        '#include "libft.h"\n#include <ctype.h>\n#include <stdio.h>\nint main() { printf("%d", ft_tolower('\''A'\'') == tolower('\''A'\'')); }' \
        "Convertir a minúscula" "1"
        
    run_test "test_tolower2" \
        '#include "libft.h"\n#include <ctype.h>\n#include <stdio.h>\nint main() { printf("%d", ft_tolower('\''z'\'') == tolower('\''z'\'')); }' \
        "Carácter ya minúscula" "1"
}

test_strchr() {
    print_header "ft_strchr"
    run_test "test_strchr1" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { printf("%d", ft_strchr("Hola mundo", '\''m'\'') == strchr("Hola mundo", '\''m'\'')); }' \
        "Encontrar carácter existente" "1"
        
    run_test "test_strchr2" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { printf("%d", ft_strchr("Hola mundo", '\''z'\'') == strchr("Hola mundo", '\''z'\'')); }' \
        "Carácter no existente" "1"
}

test_strrchr() {
    print_header "ft_strrchr"
    run_test "test_strrchr1" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { printf("%d", ft_strrchr("Hola mundo", '\''o'\'') == strrchr("Hola mundo", '\''o'\'')); }' \
        "Encontrar última ocurrencia" "1"
}

test_strncmp() {
    print_header "ft_strncmp"
    run_test "test_strncmp1" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { printf("%d", ft_strncmp("abc", "abd", 2) == strncmp("abc", "abd", 2)); }' \
        "Comparar primeros n caracteres" "1"
}

test_memchr() {
    print_header "ft_memchr"
    run_test "test_memchr1" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { printf("%d", ft_memchr("Hola mundo", '\''m'\'', 11) == memchr("Hola mundo", '\''m'\'', 11)); }' \
        "Buscar carácter en memoria" "1"
}

test_memmove() {
    print_header "ft_memmove"
    run_test "test_memmove1" \
        '#include "libft.h"\n#include <string.h>\n#include <stdio.h>\nint main() { char src[] = "origen"; char dest1[10] = "destino"; char dest2[10] = "destino"; ft_memmove(dest1, src, 6); memmove(dest2, src, 6); printf("%d", strcmp(dest1, dest2) == 0); }' \
        "Mover memoria con solapamiento" "1"
}

test_strlcat() {
    print_header "ft_strlcat"
    
    run_test "test_strlcat1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char dest[20] = "hola"; char src[] = " mundo"; size_t size = sizeof(dest); size_t len = ft_strlcat(dest, src, size); printf("%zu|%s", len, dest); }' \
        "Concatenar con espacio suficiente" "10|hola mundo"
        
    run_test "test_strlcat2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char dest[10] = "hola"; char src[] = " mundo"; size_t size = sizeof(dest); size_t len = ft_strlcat(dest, src, size); printf("%zu|%s", len, dest); }' \
        "Concatenar con espacio limitado" "10|hola mund"
}

test_strnstr() {
    print_header "ft_strnstr"
    run_test "test_strnstr1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char *s = ft_strnstr("Hola mundo", "mun", 10); if (s) printf("%s", s); else printf("NULL"); }' \
        "Buscar subcadena" "mundo"
}

# ========================================
# FUNCIONES SIN EQUIVALENTE ESTÁNDAR - SOLO MOSTRAR RESULTADO
# ========================================

test_substr() {
    print_header "ft_substr (solo resultado)"
    run_test "test_substr1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char *s = "Hola mundo"; char *sub = ft_substr(s, 2, 4); printf("%s", sub); free(sub); }' \
        "Subcadena desde posición 2, longitud 4" "la m"
}

test_strjoin() {
    print_header "ft_strjoin (solo resultado)"
    run_test "test_strjoin1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char *s1 = "Hola "; char *s2 = "mundo"; char *res = ft_strjoin(s1, s2); printf("%s", res); free(res); }' \
        "Concatenar dos strings" "Hola mundo"
}

test_strtrim() {
    print_header "ft_strtrim (solo resultado)"
    run_test "test_strtrim1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char *s = "  Hola mundo  "; char *set = " "; char *res = ft_strtrim(s, set); printf("%s", res); free(res); }' \
        "Trim de espacios" "Hola mundo"
}

test_split() {
    print_header "ft_split (solo resultado)"
    run_test "test_split1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { char **res = ft_split("Hola,mundo,libft", '\'','\''); int i = 0; while (res[i]) printf("%s ", res[i++]); for (i = 0; res[i]; i++) free(res[i]); free(res); }' \
        "Split por comas" "Hola mundo libft "
}

test_itoa() {
    print_header "ft_itoa (solo resultado)"
    run_test "test_itoa1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%s", ft_itoa(12345)); }' \
        "Convertir número positivo" "12345"
        
    run_test "test_itoa2" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { printf("%s", ft_itoa(-54321)); }' \
        "Convertir número negativo" "-54321"
}

test_strmapi() {
    print_header "ft_strmapi (solo resultado)"
    run_test "test_strmapi1" \
        '#include "libft.h"\n#include <stdio.h>\nchar to_upper(unsigned int i, char c) { (void)i; return (c >= '\''a'\'' && c <= '\''z'\'') ? c - 32 : c; }\nint main() { printf("%s", ft_strmapi("hola", to_upper)); }' \
        "Aplicar función a cada carácter" "HOLA"
}

test_striteri() {
    print_header "ft_striteri (solo resultado)"
    run_test "test_striteri1" \
        '#include "libft.h"\n#include <stdio.h>\nvoid print_index_char(unsigned int i, char *c) { printf("%d:%c ", i, *c); }\nint main() { char s[] = "hola"; ft_striteri(s, print_index_char); }' \
        "Iterar sobre string con índice" "0:h 1:o 2:l 3:a "
}

test_putchar_fd() {
    print_header "ft_putchar_fd"
    run_test "test_putchar_fd" \
        '#include "libft.h"\nint main() { ft_putchar_fd('\''X'\'', 1); }' \
        "ft_putchar_fd - Debería mostrar X" "X"
}

test_putstr_fd() {
    print_header "ft_putstr_fd"
    run_test "test_putstr_fd" \
        '#include "libft.h"\nint main() { ft_putstr_fd("Hola", 1); }' \
        "ft_putstr_fd - Debería mostrar Hola" "Hola"
}

test_put_functions() {
    print_header "Funciones put (con verificación de salida)"

    # ft_putchar_fd
    run_test "test_putchar_fd" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putchar_fd('\''X'\'', 1); return 0; }' \
        "ft_putchar_fd - Debería mostrar 'X'" "X"

    # ft_putstr_fd
    run_test "test_putstr_fd" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putstr_fd("Hola", 1); return 0; }' \
        "ft_putstr_fd - Debería mostrar 'Hola'" "Hola"

    # ft_putendl_fd - Versión mejorada
    echo -e "Hola" > expected_putendl.txt
    run_test "test_putendl_fd" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putendl_fd("Hola", 1); return 0; }' \
        "ft_putendl_fd - Debería mostrar 'Hola' + salto de línea" "$(cat expected_putendl.txt)"
    rm -f expected_putendl.txt

    # ft_putnbr_fd
    run_test "test_putnbr_fd1" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putnbr_fd(12345, 1); return 0; }' \
        "ft_putnbr_fd - Número positivo" "12345"
        
    run_test "test_putnbr_fd2" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putnbr_fd(-67890, 1); return 0; }' \
        "ft_putnbr_fd - Número negativo" "-67890"
        
    run_test "test_putnbr_fd3" \
        '#include "libft.h"\n#include <unistd.h>\nint main() { ft_putnbr_fd(0, 1); return 0; }' \
        "ft_putnbr_fd - Cero" "0"
}

test_putnbr_fd() {
    print_header "ft_putnbr_fd"
    run_test "test_putnbr_fd" \
        '#include "libft.h"\nint main() { ft_putnbr_fd(12345, 1); }' \
        "ft_putnbr_fd - Debería mostrar 12345" "12345"
}

test_lstnew() {
    print_header "ft_lstnew"
    run_test "test_lstnew1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { t_list *node = ft_lstnew("Hola"); printf("%s", (char *)node->content); free(node); }' \
        "Crear nodo con contenido 'Hola'" "Hola"
}

test_lstadd_front() {
    print_header "ft_lstadd_front"
    run_test "test_lstadd_front1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { t_list *n1 = ft_lstnew("dos"); t_list *n2 = ft_lstnew("uno"); ft_lstadd_front(&n1, n2); printf("%s", (char *)n1->content); free(n1->next); free(n1); }' \
        "Añadir nodo al frente" "uno"
}

test_lstsize() {
    print_header "ft_lstsize"
    run_test "test_lstsize1" \
        '#include "libft.h"\n#include <stdio.h>\n#include <stdlib.h>\nint main() { t_list *n1 = ft_lstnew("uno"); t_list *n2 = ft_lstnew("dos"); t_list *n3 = ft_lstnew("tres"); ft_lstadd_front(&n2, n1); ft_lstadd_front(&n3, n2); printf("%d", ft_lstsize(n3)); ft_lstclear(&n3, NULL); return 0; }' \
        "Contar nodos en la lista" "2"
}

test_lstlast() {
    print_header "ft_lstlast"
    run_test "test_lstlast1" \
        '#include "libft.h"\n#include <stdio.h>\nint main() { t_list *n1 = ft_lstnew("uno"); t_list *n2 = ft_lstnew("dos"); n1->next = n2; printf("%s", (char *)ft_lstlast(n1)->content); free(n1); free(n2); }' \
        "Obtener último nodo" "dos"
}

test_lstdelone() {
    print_header "ft_lstdelone"
    run_test "test_lstdelone1" \
        '#include "libft.h"\n#include <stdio.h>\n#include <string.h>\nvoid del(void *content) { free(content); }\nint main() { char *str = strdup("bye"); t_list *node = ft_lstnew(str); ft_lstdelone(node, del); printf("OK"); }' \
        "Eliminar un nodo" "OK"
}

# ========================================
# FUNCIÓN run_all_tests
# ========================================

run_all_tests() {
    test_isalpha
    test_isdigit
    test_isalnum
    test_isascii
    test_isprint
    test_bzero
    test_strlen
    test_memset
    test_memcpy
    test_strlcpy
    test_atoi
    test_calloc
    test_strdup
    test_toupper
    test_tolower
    test_strchr
    test_strrchr
    test_strncmp
    test_memchr
    test_memmove
    test_strlcat
    test_strnstr
    test_substr
    test_strjoin
    test_strtrim
    test_split
    test_itoa
    test_strmapi
    test_striteri
    test_putchar_fd
    test_putstr_fd
    test_put_functions
    test_putnbr_fd

    test_lstnew
    test_lstadd_front
    test_lstsize
    test_lstlast
    test_lstdelone
}

show_summary() {
    echo -e "\n${CYAN}=== RESUMEN FINAL ===${NC}"
    echo -e "Pruebas pasadas: ${GREEN}$PASSED${NC}"
    echo -e "Pruebas falladas: ${RED}$FAILED${NC}"
    echo -e "Total: $((PASSED + FAILED))"
    
    if [ $FAILED -eq 0 ]; then
        echo -e "\n${GREEN}¡Todas las pruebas pasaron! 🎉${NC}"
    else
        echo -e "\nRevisa $LOG_FILE para detalles de los fallos."
    fi
}

main() {
    echo -e "${CYAN}\nIniciando LibFT Tester...${NC}"
    
    # Compilar libft adaptado a tu Makefile
    if [ $COMPILE_BONUS -eq 1 ]; then
        echo -e "${YELLOW}Compilando con bonus...${NC}"
        # Primero compila los objetos principales
        make re > /dev/null 2>> $LOG_FILE || {
            echo -e "${RED}Error compilando parte obligatoria${NC}"
            tail -n 5 $LOG_FILE
            exit 1
        }
        # añade el bonus
        make bonus >> $LOG_FILE 2>&1 || {
            echo -e "${RED}Error compilando bonus${NC}"
            echo -e "Verifica que:"
            echo "1. Los archivos *_bonus.c existen"
            echo "2. Las funciones bonus están correctamente implementadas"
            tail -n 5 $LOG_FILE
            exit 1
        }
    else
        make re > /dev/null 2>> $LOG_FILE || {
            echo -e "${RED}Error compilando${NC}"
            tail -n 5 $LOG_FILE
            exit 1
        }
    fi

    echo "Nombre del archivo: ${NAME}"

    
    # Verificación final de que se compiló correctamente
    if [ $COMPILE_BONUS -eq 1 ] && ! nm ${NAME} | grep -q "ft_lst"; then
        echo -e "${RED}Error: Funciones bonus no encontradas en ${NAME}${NC}"
        exit 1
    fi
  
    # Ejecutar pruebas
    run_all_tests
    
    # Mostrar resumen
    show_summary
    
    # Limpieza
    make fclean > /dev/null 2>&1
    rm -rf $TEST_DIR
}

main
