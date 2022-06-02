/* eslint-disable prettier/prettier */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Offer } from 'src/offer/entities/offer.entity';
import { Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(Offer)
    private readonly offerRepository: Repository<Offer>,

    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}
  create(createUserDto: CreateUserDto) {
    return this.userRepository.save(createUserDto);
  }

  findAll() {
   return this.userRepository.find();
  }

  findOne(username:string) {
    return this.userRepository.findOne({username:`${username}`});
  }
  findTop(nb:number){
    return this.userRepository.find({
      take: nb,
      order: {
          rating: "DESC" 
      }
  });
  }

  async update(username: string, updateUserDto: UpdateUserDto) {
    const newUser = await this.userRepository.preload({ username, ...updateUserDto });
    if (newUser) {
      return this.userRepository.save(newUser);
    } else {
      throw new NotFoundException(`Le User n'existe pas `);
    }

  }
  findNbUsers(nb:number){
    return this.userRepository.find({take:nb, order:{
      rating:"DESC"
    }});
  }
  remove(id: number) {
    return `This action removes a #${id} user`;
  }
}
