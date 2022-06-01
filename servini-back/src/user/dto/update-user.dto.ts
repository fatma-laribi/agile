/* eslint-disable prettier/prettier */
import { PartialType } from '@nestjs/mapped-types';
import { IsDecimal } from 'class-validator';
import { Double } from 'typeorm';
import { CreateUserDto } from './create-user.dto';

export class UpdateUserDto {
    @IsDecimal()
    rating:number;
}


