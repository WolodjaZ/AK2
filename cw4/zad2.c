char* cesar(int shift, char* word){
	for(int a = 0; *(word+a) != '\n'; a++){
	if(*(word+a) >= 'a' && *(word+a) <= 'z'){
		*(word+a) = *(word+a) + shift;

		if(*(word+a) > 'z'){
			*(word+a) = *(word+a) - 'z' + 'a' - 1; 
		}
	}
	else if(*(word+a) >= 'A' && *(word+a) <= 'Z'){
		*(word+a) = *(word+a) + shift;

		if(*(word+a) > 'Z'){
			*(word+a) = *(word+a) - 'Z' + 'A' - 1; 
		}
	}
	if(*(word+a) != '\n'){
		return word;
		}
	}

	return word;
}